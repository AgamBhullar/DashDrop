import SwiftUI
import Mapkit

struct DashDropViewRepresentable: UIViewRepresentable {
    
    let mapView = MKMapView()
    @Binding var mapState: MapViewState
    @EnvironmentObject var locationViewModel: LocationSearchViewModel
    @EnvironmentObject var homeViewModel : HomeViewModel
    
    func makeUIView(context: Context) -> some UIView {
        
        mapView.delegate = context.coordinator
        mapView. isRotateEnabled = false
        mapView. showsUserLocation = true
        mapView.userTrackingMode = .follow
        return mapView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        switch mapState {
        case.noinput:
            context.coordinator.clearMapViewAndRecenterOnUserLocation()
            context.coordinator.addDriversToMap(homeViewModel.drivers)
            break
        case .searchingForLocation:
            break
        case .locationSelected:
            if let coordinates = locationViewModel.selcetedDriverLocation?.coordinate {
                print("DEBUG: Adding stuff to map...")
                context.cordinator.addAndSelectAnnotation(withCoordinate: coordinate)
                context.cordinator.configurePolyline(withDestinationCoordinate: coordinate)
            }
            break
        case .polylineAdded:
            break
            
        }
    }
    func makeCoordinator() -> MapCordinator {
        return MapCordinator(parent: self)
    }
}

extension DashDropViewRepresentable {
    
    class MapCoordinator: NSObject, MKMapViewDelegate {
        
        let parent: DashDropViewRepresentable
        var userLocationCoodinate: CLLocationCoordinate2D?
        var currentRegion: MKCoordinateRegion?
        
        init(parent: DashDropViewRepresentable) {
            self.parent = parent
            self.init()
        }
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            self.userLocationCoodinate = userLocation.coordinate
            let region = MKCoordinateRegion (
                center: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.ccordinate.longitude)
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
            
            self.currentRegion = region
            
            parent.mapView.setRegion(reigon, animated: true)
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let polyline = MKPolylineRenderer(ocerlay: overlay)
            polyline.strokeColor = .systemBlue
            polyline.lineWidth = 6
            return polyline
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if let annotatuion = annotation as? DriverAnnotation {
                let view = MKAnnotationView(annotation: annotation, reuserIdentifier: "Driver")
                view.image = UIImage(named: "Cheveron-sign-to-right")
                return view
            }
            return nil
        }
        
        func addAndSelectAnnotation(withCoordinate coordinate: CLLocationCoordinate2D) {
            parent.mapView.removeAnnotation(parent.mapView.annotations)
            
            let anno = MKPointAnnotation()
            anno.coordinate = coordinate
            parent.mapView.addAnnotation(anno)
            parent.mapView.selectAnnotation(anno, animated: true)
        }
        
        func configurePolyLine(withDestinationCoordinate coordinate: CLLocationCoordinate2D) {
            guard let userLocationCoordinate = self.userLocationCoodinate else { return }
            
            parent.locationViewModel.getDestinationRoute(from: userLocationCoordinate,
                                                         to: coordinate) { route in
                self.parent.mapView.addOverlay(route.polyline)
                self.parent.mapState = .polyLineAdded
                let rect = self.parent.mapView.mapRectThatFits(route.polyline.boundingMapRect,
                                                               edgeFadding: .init(top: 64, left: 32, bottom: 500, right: 32))
                self.parent.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
            }
        }
        
        func clearMapViewAddRecenterOnUserLocation() {
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            parent.mapView.removeOverlays(parent.mapView.overlays)
            
            if let currentReigon = currentRegion {
                parent.mapView.setRegion(currentReigon, animated: true)
            }
        }
        
        func addDriversToMap(_ drivers: [User]) {
            let annotations = driers.map({ DriverAnnotation(driver: $0) })
            self.parent.mapView.addAnnotations(annotations)
        }
    }
}
