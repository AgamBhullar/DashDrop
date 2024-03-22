
import SwiftUI
import MapKit

struct OrdersView: View {
    @ObservedObject var viewModel: OrdersViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var selectedOrder: Order?
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("Order History")
                    .font(.largeTitle)
                    .bold()
                    //.padding()
            }
            
            List(sortedOrders) { order in
                Button(action: {
                    self.selectedOrder = order
                }) {
                    OrderRow(order: order)
                }
            }
            .listStyle(PlainListStyle())
            .background(Color.clear)
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                if let user = authViewModel.currentUser {
                    viewModel.fetchCompletedOrders(forUser: user)
                }
            }
        }
//        .navigationTitle("Order History")
//        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.title)
                        .imageScale(.medium)
                        .foregroundColor(Color("CustomColor1"))
                }
            }
        }
        .background(Color(.systemGroupedBackground))
        .sheet(item: $selectedOrder) { order in
            OrderDetailSheet(order: order, viewModel: viewModel)
        }
    }
    var sortedOrders: [Order] {
        viewModel.completedOrders.sorted {
            guard let date1 = $0.creationDate?.dateValue(), let date2 = $1.creationDate?.dateValue() else {
                return false
            }
            return date1 > date2
        }
    }
}


struct OrderRow: View {
    var order: Order
    var body: some View {
        HStack {
            if let packageType = PackageType(description: order.packageType) {
                Image(packageType.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .cornerRadius(10)
                    .padding()
            }
            VStack(alignment: .leading) {
                Text(order.dropoffLocationName)
                    .font(.headline)
                    .foregroundColor(Color.theme.primaryTextColor)
                Text(order.pickupLocationAddress)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(order.formattedCreationDate)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(order.tripCost.toCurrency())
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct OrderDetailSheet: View {
    let order: Order
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: OrdersViewModel

    // Updated to use direct MKMapView via UIViewRepresentable
    var body: some View {
        NavigationView {
            VStack {
                OrderMap(order: order)
                    //.edgesIgnoringSafeArea(.top)
                    .frame(height: 220)
                    .cornerRadius(10)
                    .shadow(color: .black.opacity(0.6), radius: 10)
                    .padding()
                
                List {
                    Section(header: Text("Order ID: \(order.orderId ?? "N/A")").font(.headline)) {
                        // List content
                        HStack {
                            Text("Driver Name:")
                            Spacer()
                            Text(order.driverName)
                        }
                        HStack {
                            Text("Pickup Location:")
                            Spacer()
                            Text(order.pickupLocationName)
                        }
                        HStack {
                            Text("Dropoff Location:")
                            Spacer()
                            Text(order.dropoffLocationName)
                        }
                        HStack {
                            Text("Total Cost:")
                            Spacer()
                            Text("$\(order.tripCost, specifier: "%.2f")")
                        }
                        Button("VIEW RECEIPT") {
                            viewModel.fetchReceipt(forOrder: order.id)
                        }
                        .frame(width: 125, height: 40)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                }
                .sheet(item: $viewModel.selectedReceipt) { receipt in
                    if let url = URL(string: receipt.receiptImageUrl ?? "") {
                        FullScreenImageView(url: url)
                    } else {
                        Text("Please refresh to view the image")
                    }
                }
            }
            .navigationBarTitle("Order Details", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark") // System image for cross
                            .foregroundColor(Color.theme.primaryTextColor)
                    }
                }
            }
        }
    }
}

struct OrderMap: UIViewRepresentable {
    let order: Order

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        configureMap(mapView: mapView, with: context.coordinator)
        
        // Add annotations for pickup and dropoff locations
        let pickupAnnotation = MKPointAnnotation()
        pickupAnnotation.coordinate = CLLocationCoordinate2D(latitude: order.pickupLocation.latitude, longitude: order.pickupLocation.longitude)
        pickupAnnotation.title = "Pickup"
        
        let dropoffAnnotation = MKPointAnnotation()
        dropoffAnnotation.coordinate = CLLocationCoordinate2D(latitude: order.dropoffLocation.latitude, longitude: order.dropoffLocation.longitude)
        dropoffAnnotation.title = "Dropoff"
        
        mapView.addAnnotations([pickupAnnotation, dropoffAnnotation])
        
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func configureMap(mapView: MKMapView, with coordinator: Coordinator) {
        // Define the source and destination coordinates
        let sourceCoordinate = CLLocationCoordinate2D(latitude: order.pickupLocation.latitude, longitude: order.pickupLocation.longitude)
        let destinationCoordinate = CLLocationCoordinate2D(latitude: order.dropoffLocation.latitude, longitude: order.dropoffLocation.longitude)
        
        // Create map items from coordinates
        let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinate)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate)
        
        let sourceItem = MKMapItem(placemark: sourcePlacemark)
        let destinationItem = MKMapItem(placemark: destinationPlacemark)
        
        // Create a directions request
        let directionsRequest = MKDirections.Request()
        directionsRequest.source = sourceItem
        directionsRequest.destination = destinationItem
        directionsRequest.transportType = .automobile // Choose appropriate transport type
        
        // Calculate the directions
        let directions = MKDirections(request: directionsRequest)
        directions.calculate { response, error in
            guard let response = response, let route = response.routes.first else {
                print("Error getting directions: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            mapView.addOverlay(route.polyline)
            
            // Set the map region to the route's bounding map rect with padding
            let rect = route.polyline.boundingMapRect
            mapView.setVisibleMapRect(rect, edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20), animated: true)
        }
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: OrderMap

        init(_ parent: OrderMap) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let routePolyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: routePolyline)
                renderer.strokeColor = .systemBlue
                renderer.lineWidth = 6
                return renderer
            }
            return MKOverlayRenderer()
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            switch annotation.title {
            case "Pickup":
                let view = MKAnnotationView(annotation: annotation, reuseIdentifier: "pickup")
                view.image = UIImage(systemName: "person.fill") // Customize as needed
                view.canShowCallout = true
                return view
            case "Dropoff":
                let view = MKAnnotationView(annotation: annotation, reuseIdentifier: "dropoff")
                view.image = UIImage(systemName: "shippingbox.fill") // Customize as needed
                view.canShowCallout = true
                return view
            default:
                return nil
            }
        }
    }
}






//struct OrderMap: UIViewRepresentable {
//    let order: Order
//
//    func makeUIView(context: Context) -> MKMapView {
//        let mapView = MKMapView()
//        mapView.delegate = context.coordinator
//
//        // Define and add the polyline
//        let pickupCoordinate = CLLocationCoordinate2D(latitude: order.pickupLocation.latitude, longitude: order.pickupLocation.longitude)
//        let dropoffCoordinate = CLLocationCoordinate2D(latitude: order.dropoffLocation.latitude, longitude: order.dropoffLocation.longitude)
//        let coordinates = [pickupCoordinate, dropoffCoordinate]
//        let polyline = MKPolyline(coordinates: coordinates, count: 2)
//        mapView.addOverlay(polyline)
//
//        // Add annotations for pickup and dropoff locations
//               let pickupAnnotation = MKPointAnnotation()
//               pickupAnnotation.coordinate = pickupCoordinate
//               pickupAnnotation.title = "Pickup"
//
//               let dropoffAnnotation = MKPointAnnotation()
//               dropoffAnnotation.coordinate = dropoffCoordinate
//               dropoffAnnotation.title = "Dropoff"
//
//               mapView.addAnnotations([pickupAnnotation, dropoffAnnotation])
//
//        // Adjust the map region to fit the polyline
//        let rect = mapView.mapRectThatFits(polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 44,
//                                                                                               left: 32,
//                                                                                               bottom: 500,
//                                                                                               right: 32))
//               mapView.setVisibleMapRect(rect, animated: true)
//
//        return mapView
//    }
//
//    func updateUIView(_ uiView: MKMapView, context: Context) {}
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    class Coordinator: NSObject, MKMapViewDelegate {
//        var parent: OrderMap
//
//        init(_ parent: OrderMap) {
//            self.parent = parent
//        }
//
////        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
////            if overlay is MKPolyline {
////                let renderer = MKPolylineRenderer(overlay: overlay)
////                renderer.strokeColor = .blue
////                renderer.lineWidth = 4
////                return renderer
////            }
////            return MKOverlayRenderer()
////        }
//        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//            let polyline = MKPolylineRenderer(overlay: overlay)
//            polyline.strokeColor = .systemBlue
//            polyline.lineWidth = 6
//            return polyline
//        }
//
//        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//            // Distinguish between Pickup and Dropoff
//            switch annotation.title {
//            case "Pickup":
//                let view = MKAnnotationView(annotation: annotation, reuseIdentifier: "pickup")
//                view.image = UIImage(systemName: "person.fill") // Use your custom image for the pickup location
//                view.canShowCallout = true
//                return view
//            case "Dropoff":
//                let view = MKAnnotationView(annotation: annotation, reuseIdentifier: "dropoff")
//                view.image = UIImage(systemName: "shippingbox.fill") // Use your custom image for the dropoff location
//                view.canShowCallout = true
//                return view
//            default:
//                return nil
//            }
//        }
//    }
//}
//
