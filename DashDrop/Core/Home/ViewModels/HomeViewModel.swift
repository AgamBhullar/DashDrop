//
//  HomeViewModel.swift
//  DashDrop
//
//  Created by Agam Bhullar on 3/5/24.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import Combine
import MapKit

class HomeViewModel: NSObject, ObservableObject {
    static let shared = HomeViewModel() 
    
    // MARK: - Properties
    
    @Published var drivers = [User]()
    @Published var order: Order?
    @Published var receipt: Receipt?
    private let service = UserService.shared
    @Published var currentUser: User?
    var routeToPickupLocation: MKRoute?
    private var cancellables = Set<AnyCancellable>()
    @Published var selectedPackageType: PackageType?
    //private var currentUser: User?
    
    //Location search properties
    @Published var results = [MKLocalSearchCompletion]()
    @Published var selectedDashDropLocation: DashDropLocation?
    @Published var pickupTime: String?
    @Published var dropOffTime: String?
    @Published var selectedQRCodeImage: UIImage?
    
    private let searchCompleter = MKLocalSearchCompleter()
    var userLocation: CLLocationCoordinate2D?
    
    var queryFragment: String = "" {
        didSet {
            searchCompleter.queryFragment = queryFragment
        }
    }

    //MARK: - Lifecycle
    
    override init() {
        super.init()
        fetchUser()
        listenForDriverLocationUpdates()
        
        searchCompleter.delegate = self
        searchCompleter.queryFragment = queryFragment
    }
    
    //MARK: - User API
    
    func fetchUser() {
        service.$user
            .sink { user in
                guard let user = user else { return }
                self.currentUser = user
                
                if user.accountType == .customer {
                    self.fetchDrivers()
                    self.addOrderObserverForCustomer()
                } else {
                    self.addOrderObserverForDriver()
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Customer API

extension HomeViewModel {
    
    func listenForDriverLocationUpdates() {
        Firestore.firestore().collection("users")
            .whereField("accountType", isEqualTo: AccountType.driver.rawValue)
            .addSnapshotListener { snapshot, error in
                guard let snapshot = snapshot else {
                    print("Error fetching driver updates: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                snapshot.documentChanges.forEach { change in
                    if change.type == .modified {
                        if let updatedDriver = try? change.document.data(as: User.self) {
                            if let index = self.drivers.firstIndex(where: { $0.uid == updatedDriver.uid }) {
                                self.drivers[index] = updatedDriver
                            } else {
                                self.drivers.append(updatedDriver)
                            }
                        }
                    }
                }
            }
    }
    
    func resetOrderAndUserState() {
            self.order = nil
            //self.receipt = nil
        }
    
    func resetDriverState() {
        self.order = nil
    }
    
    func addOrderObserverForCustomer() {
        guard let currentUser = currentUser, currentUser.accountType == .customer else { return }
        
        Firestore.firestore().collection("orders")
            .whereField("customerUid", isEqualTo: currentUser.uid)
            .whereField("isCompletedForCustomer", isEqualTo: false)
            .whereField("isCompletedForDriver", isEqualTo: false)
            .whereField("isRejectedForCustomer", isEqualTo: false)
            .whereField("isRejectedForDriver", isEqualTo: false)
            .addSnapshotListener { snapshot, _ in
                guard let change = snapshot?.documentChanges.first,
                        change.type == .added
                        || change.type == .modified else { return }
                
                guard let order = try? change.document.data(as: Order.self) else { return }
                self.order = order
                print("DEBUG: Updated trip state is \(order.state)")
        }
    }
    
    func fetchDrivers() {
        Firestore.firestore().collection("users")
            .whereField("accountType", isEqualTo: AccountType.driver.rawValue)
            .getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                let drivers = documents.compactMap({ try? $0.data(as: User.self) })
                self.drivers = drivers
                
        }
    }
    
    func markOrderAsRejectedForCustomer(orderId: String) {
        Firestore.firestore().collection("orders").document(orderId).updateData(["isRejectedForCustomer": true]) { error in
            if let error = error {
                print("DEBUG: Error marking order as rejected: \(error.localizedDescription)")
            } else {
                print("DEBUG: Order marked as rejected successfully.")
                // After marking as completed, you may want to reset the local app state
                self.resetOrderAndUserState()
            }
        }
    }
    
    func markOrderAsCompletedForCustomer(orderId: String) {
        Firestore.firestore().collection("orders").document(orderId).updateData(["isCompletedForCustomer": true]) { error in
            if let error = error {
                print("DEBUG: Error marking order as completed: \(error.localizedDescription)")
            } else {
                print("DEBUG: Order marked as completed successfully.")
                // After marking as completed, you may want to reset the local app state
                self.resetOrderAndUserState()
            }
        }
    }
    
    func requestOrder() {
        guard let currentUser = currentUser,
              let dropoffLocation = selectedDashDropLocation,
              let currentLocation = LocationManager.shared.userLocation,
              let selectedPackage = selectedPackageType else { return }

        let customerLocation = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
        let dropoffCLLocation = CLLocation(latitude: dropoffLocation.coordinate.latitude, longitude: dropoffLocation.coordinate.longitude)


        // Ensure drivers are fetched before this point, or fetch them here (asynchronously, with a completion handler).
        let closestDriver = drivers.map { driver -> (driver: User, distance: CLLocationDistance) in
            let driverLocation = CLLocation(latitude: driver.coordinates.latitude, longitude: driver.coordinates.longitude)
            let distance = customerLocation.distance(from: driverLocation)
            return (driver, distance)
        }.min(by: { $0.distance < $1.distance })?.driver

        guard let driver = closestDriver else {
            print("No drivers available")
            return
        }

        let dropoffGeoPoint = GeoPoint(latitude: dropoffLocation.coordinate.latitude, longitude: dropoffLocation.coordinate.longitude)
        let pickupGeoPoint = GeoPoint(latitude: currentLocation.latitude, longitude: currentLocation.longitude)

        //pickup address
        getPlacemark(forLocation: customerLocation) { [weak self] placemark, error in
            guard let self = self, let placemark = placemark else { return }
            let tripCost = self.computeRidePrice(forType: .box)

            let pickupLocationName = placemark.name ?? "Current Location"
            let pickupLocationAddress = self.addressFromPlacemark(placemark)
            
           // deliver address
            getPlacemark(forLocation: dropoffCLLocation) { [weak self] pickupPlacemark, error in
                guard let self = self, let pickupPlacemark = pickupPlacemark else { return }
                let deliveryLocationAddress = self.deliveryAddressFromPlacemark(pickupPlacemark)
                
                if let selectedImage = self.selectedQRCodeImage {
                    ImageUploader.uploadImage(image: selectedImage) { imageUrl in
                        let order = self.createOrder(currentUser: currentUser, driver: driver, pickupLocationName: pickupLocationName, dropoffLocation: dropoffLocation, pickupLocationAddress: pickupLocationAddress, deliveryLocationAddress: deliveryLocationAddress, pickupGeoPoint: pickupGeoPoint, dropoffGeoPoint: dropoffGeoPoint, tripCost: tripCost, imageUrl: imageUrl, selectedPackage: selectedPackage)
                        self.uploadOrderData(order)
                    }
                } else {
                    let order = self.createOrder(currentUser: currentUser, driver: driver, pickupLocationName: pickupLocationName, dropoffLocation: dropoffLocation, pickupLocationAddress: pickupLocationAddress, deliveryLocationAddress: deliveryLocationAddress, pickupGeoPoint: pickupGeoPoint, dropoffGeoPoint: dropoffGeoPoint, tripCost: tripCost, imageUrl: nil, selectedPackage: selectedPackage)
                    self.uploadOrderData(order)
                }
            }
        }
    }

    private func createOrder(currentUser: User, driver: User, pickupLocationName: String, dropoffLocation: DashDropLocation, pickupLocationAddress: String, deliveryLocationAddress: String, pickupGeoPoint: GeoPoint, dropoffGeoPoint: GeoPoint, tripCost: Double, imageUrl: String?, selectedPackage: PackageType, isCompletedForCustomer: Bool = false, isCompletedForDriver: Bool = false, isRejectedForCustomer: Bool = false, isRejectedForDriver: Bool = false) -> Order {
        return Order(
            customerUid: currentUser.uid,
            driverUid: driver.uid,
            customerName: currentUser.fullname,
            driverName: driver.fullname,
            customerLocation: pickupGeoPoint,
            driverLocation: driver.coordinates,
            pickupLocationName: pickupLocationName,
            dropoffLocationName: dropoffLocation.title,
            pickupLocationAddress: pickupLocationAddress,
            deliveryLocationAddress: deliveryLocationAddress,
            pickupLocation: pickupGeoPoint,
            dropoffLocation: dropoffGeoPoint,
            tripCost: tripCost,
            distanceToCustomer: 0, // This could be calculated if needed
            travelTimeToCustomer: 0, // This could be calculated based on the distance
            state: .requested,
            qrcodeImageUrl: imageUrl ?? "",
            selectedLabelOption: imageUrl != nil ? "The customer uploaded an image of the QR code" : "The customer selected the prepaid label option.",
            packageType: selectedPackage.description,
            isCompletedForCustomer: isCompletedForCustomer,
            isCompletedForDriver: isCompletedForDriver,
            isRejectedForCustomer: isRejectedForCustomer,
            isRejectedForDriver: isRejectedForDriver,
            creationDate: nil
        )
    }


    private func uploadOrderData(_ order: Order) {
        guard let encodedOrder = try? Firestore.Encoder().encode(order) else { return }
        Firestore.firestore().collection("orders").document().setData(encodedOrder) { _ in
            print("DEBUG: Did upload trip to firestore")
        }
    }
    
    func cancelOrderAsCustomer() {
        updateOrderState(state: .customerCancelled)
    }
}

// MARK: - Driver API

extension HomeViewModel {
    func addOrderObserverForDriver() {
        guard let currentUser = currentUser, currentUser.accountType == .driver else { return }
        
        Firestore.firestore().collection("orders")
            .whereField("driverUid", isEqualTo: currentUser.uid)
            .addSnapshotListener { snapshot, _ in
                guard let change = snapshot?.documentChanges.first,
                        change.type == .added
                        || change.type == .modified else { return }
                
                guard let order = try? change.document.data(as: Order.self) else { return }
                self.order = order
                
                self.getDestinationRoute(from: order.driverLocation.toCoordinate(),
                                         to: order.pickupLocation.toCoordinate()) { route in
                    self.routeToPickupLocation = route
                    self.order?.travelTimeToCustomer = Int(route.expectedTravelTime / 60)
                    self.order?.distanceToCustomer = route.distance
                }
        }
    }
    
//    func fetchOrders() {
//        guard let currentUser = currentUser else { return }
//        
//        Firestore.firestore().collection("orders")
//            .whereField("driverUid", isEqualTo: currentUser.uid)
//            .getDocuments { snapshot, _ in
//                guard let documents = snapshot?.documents, let document = documents.first else { return }
//                guard let order = try? document.data(as: Order.self) else { return }
//                
//                self.order = order
//                
//                self.getDestinationRoute(from: order.driverLocation.toCoordinate(),
//                                         to: order.pickupLocation.toCoordinate()) { route in
//                    
//                    self.order?.travelTimeToCustomer = Int(route.expectedTravelTime / 60)
//                    self.order?.distanceToCustomer = route.distance
//                }
//            }
//    }
    
    func fetchOrders(completion: @escaping () -> Void) {
        guard let currentUser = currentUser else { return }
        
        Firestore.firestore().collection("orders")
            .whereField("driverUid", isEqualTo: currentUser.uid)
            .getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents, let document = documents.first else {
                    completion()
                    return
                }
                guard let order = try? document.data(as: Order.self) else {
                    completion()
                    return
                }
                
                self.order = order
                
                self.getDestinationRoute(from: order.driverLocation.toCoordinate(),
                                         to: order.pickupLocation.toCoordinate()) { route in
                    self.order?.travelTimeToCustomer = Int(route.expectedTravelTime / 60)
                    self.order?.distanceToCustomer = route.distance
                    completion()
                }
            }
    }

    
    func uploadReceiptImage(forOrder orderID: String, image: UIImage) {
        // First, upload the image
        ImageUploader.uploadImage(image: image) { imageUrl in
            // Define a new document in the 'receipts' collection with the same orderID
            let receiptRef = Firestore.firestore().collection("receipts").document(orderID)
            
            // Prepare the data to be saved
            let receiptData = ["receiptImageUrl": imageUrl, "orderID": orderID, "uploadDate": Timestamp()]
            
            // Set the data for the receipt document
            receiptRef.setData(receiptData) { error in
                if let error = error {
                    print("DEBUG: Failed to save receipt data: \(error.localizedDescription)")
                } else {
                    print("DEBUG: Receipt data saved successfully.")
                }
            }
        }
    }
    
//    func fetchReceipt(forOrder orderID: String) {
//        let receiptRef = Firestore.firestore().collection("receipts").document(orderID)
//        receiptRef.getDocument { (document, error) in
//            if let document = document, document.exists, let receipt = try? document.data(as: Receipt.self) {
//                DispatchQueue.main.async {
//                    self.receipt = receipt
//                }
//            } else {
//                print("Document does not exist or failed to decode: \(error?.localizedDescription ?? "")")
//            }
//        }
//    }

    func fetchReceipt(forOrder orderID: String, completion: @escaping () -> Void) {
        let receiptRef = Firestore.firestore().collection("receipts").document(orderID)
        receiptRef.getDocument { (document, error) in
            if let document = document, document.exists, let receipt = try? document.data(as: Receipt.self) {
                DispatchQueue.main.async {
                    self.receipt = receipt
                }
            } else {
                print("Document does not exist or failed to decode: \(error?.localizedDescription ?? "")")
            }
            completion()
        }
    }

    
    func refreshOrder() {
        guard let orderID = order?.id else { return }
        
        let orderRef = Firestore.firestore().collection("orders").document(orderID)
        orderRef.getDocument { (document, error) in
            if let document = document, document.exists, let updatedOrder = try? document.data(as: Order.self) {
                DispatchQueue.main.async {
                    self.order = updatedOrder
                }
            } else {
                print("Error fetching updated order: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }

 
    func rejectOrder() {
        updateOrderState(state: .rejected)
    }
    
    func acceptOrder() {
        updateOrderState(state: .accepted)
    }
    
    func cancelOrderAsDriver() {
        updateOrderState(state: .driverCancelled)
    }
    
    func preDelivery() {
        updateOrderState(state: .predeliver)
    }
    
    func deliveredOrder() {
        updateOrderState(state: .delivered)
    }
    
    
    private func updateOrderState(state: OrderState) {
        guard let order = order else { return }
        
        var data = ["state": state.rawValue]
        
        if state == .accepted {
            data["travelTimeToCustomer"] = order.travelTimeToCustomer
        }
        
        Firestore.firestore().collection("orders").document(order.id).updateData(data) { _ in
            print("DEBUG: Did update order with state \(state)")
        }
    }
    
    func markOrderAsRejectedForDriver(orderId: String) {
        Firestore.firestore().collection("orders").document(orderId).updateData(["isRejectedForDriver": true]) { error in
            if let error = error {
                print("DEBUG: Error marking order as rejected: \(error.localizedDescription)")
            } else {
                print("DEBUG: Order marked as rejected successfully.")
                // After marking as completed, you may want to reset the local app state
                self.resetOrderAndUserState()
            }
        }
    }
    
    func markOrderAsCompletedForDriver(orderId: String) {
        Firestore.firestore().collection("orders").document(orderId).updateData(["isCompletedForDriver": true]) { error in
            if let error = error {
                print("Error marking order as completed: \(error.localizedDescription)")
            } else {
                print("Order marked as completed successfully.")
                // After marking as completed, you may want to reset the local app state
                self.resetOrderAndUserState()
            }
        }
    }
    
    
}

// MARK: - Location Search Helpers

extension HomeViewModel {
    
    func addressFromPlacemark(_ placemark: CLPlacemark) -> String {
        var result = ""
        
        
        if let subthoroughfare = placemark.subThoroughfare {
            result += "\(subthoroughfare) "
        }
        
        if let thoroughfare = placemark.thoroughfare {
            result += thoroughfare
        }
        
        if let subadministrativeArea = placemark.subAdministrativeArea {
            result += ", \(subadministrativeArea)"
        }
        
        return result
    }
    
    func deliveryAddressFromPlacemark(_ pickupPlacemark: CLPlacemark) -> String {
        var result = ""
        
        
        if let subthoroughfare = pickupPlacemark.subThoroughfare {
            result += "\(subthoroughfare) "
        }
        
        if let thoroughfare = pickupPlacemark.thoroughfare {
            result += thoroughfare
        }
        
        if let subadministrativeArea = pickupPlacemark.subAdministrativeArea {
            result += ", \(subadministrativeArea)"
        }
        
        return result
    }
    
    func getPlacemark(forLocation location: CLLocation, completion: @escaping(CLPlacemark?, Error?) -> Void) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let placemark = placemarks?.first else { return }
            completion(placemark, nil)
        }
    }
    
    func selectLocation(_ localSearch: MKLocalSearchCompletion, config: LocationResultsViewConfig) {
        locationSearch(forLocalSearchCompletion: localSearch) { response, error in
            if let error = error {
                print("DEBUG: Location search failed with error \(error.localizedDescription)")
                return
            }
            
            guard let item = response?.mapItems.first else { return }
            let coordinate = item.placemark.coordinate
            
            switch config {
            case .order:
                self.selectedDashDropLocation = DashDropLocation(title: localSearch.title, 
                                                                 coordinate: coordinate)
                
            case .saveLocation(let viewModel):
                guard let uid = Auth.auth().currentUser?.uid else { return }
                let savedLocation = SavedLocation(title: localSearch.title,
                                                  address: localSearch.subtitle,
                                                  coordinates: GeoPoint(latitude: coordinate.latitude,
                                                                        longitude: coordinate.longitude))
                guard let encodedLocation = try? Firestore.Encoder().encode(savedLocation) else { return }
                Firestore.firestore().collection("users").document(uid).updateData([
                    viewModel.databaseKey: encodedLocation
                ])
            }
        }
    }
    
    func locationSearch(forLocalSearchCompletion localSearch: MKLocalSearchCompletion, completion: @escaping MKLocalSearch.CompletionHandler) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = localSearch.title.appending(localSearch.subtitle)
        let search = MKLocalSearch(request: searchRequest)
        
        search.start(completionHandler: completion)
    }
    
    func computeRidePrice(forType type: PackageType) -> Double {
        guard let destCoordinate = selectedDashDropLocation?.coordinate else { return 0.0 }
        guard let userCoordinate = self.userLocation else { return 0.0 }
        
        let userLocation = CLLocation(latitude: userCoordinate.latitude,
                                      longitude: userCoordinate.longitude)
        let destination = CLLocation(latitude: destCoordinate.latitude,
                                     longitude: destCoordinate.longitude)
        
        let orderDistanceInMeters = userLocation.distance(from: destination)
        return type.computePrice(for: orderDistanceInMeters)
    }
    
    func getDestinationRoute(from userLocation: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D, completion: @escaping(MKRoute) -> Void) {
        let userPlacemark = MKPlacemark(coordinate: userLocation)
        let destPlacemark = MKPlacemark(coordinate: destination)
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: userPlacemark)
        request.destination = MKMapItem(placemark: destPlacemark)
        let directions = MKDirections(request: request)
        
        directions.calculate { response, error in
            if let error = error {
                print("DEBUG: Failed to get directions with error \(error.localizedDescription)")
                return
            }
            
            guard let route = response?.routes.first else { return }
            self.configurePickupAndDropoffTimes(with: route.expectedTravelTime)
            completion(route)
        }
    }
    
    func configurePickupAndDropoffTimes(with expectedTravelTime: Double) {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        
        pickupTime = formatter.string(from: Date())
        dropOffTime = formatter.string(from: Date() + expectedTravelTime)
    }
}

extension HomeViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
    }
}
