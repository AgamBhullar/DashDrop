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
    
    // MARK: - Properties
    
    @Published var drivers = [User]()
    @Published var order: Order?
    private let service = UserService.shared
    @Published var currentUser: User?
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
        
        searchCompleter.delegate = self
        searchCompleter.queryFragment = queryFragment
    }
    
    //MARK: - User API
    
    func fetchUser() {
        service.$user
            .sink { user in
                guard let user = user else { return }
                self.currentUser = user
                //self.currentUser = user
                
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
    
    func addOrderObserverForCustomer() {
        guard let currentUser = currentUser, currentUser.accountType == .customer else { return }
        
        Firestore.firestore().collection("orders")
            .whereField("customerUid", isEqualTo: currentUser.uid)
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
    
//    func requestOrder() {
//        guard let driver = drivers.first else { return }
//        guard let currentUser = currentUser else { return }
//        guard let dropoffLocation = selectedDashDropLocation else { return }
//        let dropoffGeoPoint = GeoPoint(latitude: dropoffLocation.coordinate.latitude,
//                                       longitude: dropoffLocation.coordinate.longitude)
//        let userLocation = CLLocation(latitude: currentUser.coordinates.latitude,
//                                      longitude: currentUser.coordinates.longitude)
//        
//        getPlacemark(forLocation: userLocation) { placemark, error in
//            guard let placemark = placemark else { return }
//            let tripCost = self.computeRidePrice(forType: .box)
    
    func requestOrder() {
        guard let driver = drivers.first,
              let currentUser = currentUser,
              let dropoffLocation = selectedDashDropLocation,
              let currentLocation = LocationManager.shared.userLocation,
              let selectedPackage = selectedPackageType else { return }

        let dropoffGeoPoint = GeoPoint(latitude: dropoffLocation.coordinate.latitude, longitude: dropoffLocation.coordinate.longitude)
        let pickupGeoPoint = GeoPoint(latitude: currentLocation.latitude, longitude: currentLocation.longitude)

        let userLocation = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)

        getPlacemark(forLocation: userLocation) { [weak self] placemark, error in
            guard let self = self, let placemark = placemark else { return }
            let tripCost = self.computeRidePrice(forType: .box)
            
            // Determine the pickup location name and address from the placemark
            let pickupLocationName = placemark.name ?? "Current Location"
            let pickupLocationAddress = self.addressFromPlacemark(placemark)
            
            // Check if there is an image to be uploaded
            if let selectedImage = self.selectedQRCodeImage {
                // Upload image then get the URL
                ImageUploader.uploadImage(image: selectedImage) { imageUrl in
                    // Create the Order with the image URL
                    
                    let order = Order(
                        customerUid: currentUser.uid,
                        driverUid: driver.uid,
                        customerName: currentUser.fullname,
                        driverName: driver.fullname,
                        customerLocation: GeoPoint(latitude: currentLocation.latitude, longitude: currentLocation.longitude), // Use current location for customerLocation
                        driverLocation: driver.coordinates,
                        pickupLocationName: pickupLocationName,
                        dropoffLocationName: dropoffLocation.title,
                        pickupLocationAddress: pickupLocationAddress,
                        pickupLocation: pickupGeoPoint, // Use GeoPoint created from current location
                        dropoffLocation: dropoffGeoPoint,
                        tripCost: tripCost,
                        distanceToCustomer: 0,
                        travelTimeToCustomer: 0,
                        state: .requested,
                        qrcodeImageUrl: imageUrl, // Include the image URL if available
                        selectedLabelOption: "The customer uploaded an image of the QR code",
                        packageType: selectedPackage.description
                    )
                    
                    // Now upload order data including the image URL
                    self.uploadOrderData(order)
                    print("DEBUG: Trip is \(order)")
                }
            } else {
                // No image, proceed with order creation without image URL
                let order = Order(
                    customerUid: currentUser.uid,
                    driverUid: driver.uid,
                    customerName: currentUser.fullname,
                    driverName: driver.fullname,
                    customerLocation: GeoPoint(latitude: currentLocation.latitude, longitude: currentLocation.longitude), // Use current location for customerLocation
                    driverLocation: driver.coordinates,
                    pickupLocationName: pickupLocationName,
                    dropoffLocationName: dropoffLocation.title,
                    pickupLocationAddress: pickupLocationAddress,
                    pickupLocation: pickupGeoPoint, // Use GeoPoint created from current location
                    dropoffLocation: dropoffGeoPoint,
                    tripCost: tripCost,
                    distanceToCustomer: 0,
                    travelTimeToCustomer: 0,
                    state: .requested,
                    selectedLabelOption: "The customer selected the prepaid label option.",
                    packageType: selectedPackage.description
                )
                
                // Now upload order data without the image URL
                print("DEBUG: Trip is \(order)")
                self.uploadOrderData(order)
            }
        }
    }


    private func uploadOrderData(_ order: Order) {
        guard let encodedOrder = try? Firestore.Encoder().encode(order) else { return }
        Firestore.firestore().collection("orders").document().setData(encodedOrder) { _ in
            print("DEBUG: Did upload trip to firestore")
        }
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
    
    func rejectOrder() {
        updateOrderState(state: .rejected)
    }
    
    func acceptOrder() {
        updateOrderState(state: .accepted)
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
