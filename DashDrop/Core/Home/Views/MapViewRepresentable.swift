//
//  MapViewRepresentable.swift
//  DashDrop
//
//  Created by Agam Bhullar on 3/1/24.
//

import SwiftUI
import MapKit

struct MapViewRepresentable: UIViewRepresentable {
    
    let mapView = MKMapView()
    let locationManager = LocationManager.shared
    @Binding var mapState: MapViewState
//    @EnvironmentObject var locationViewModel: LocationSearchViewModel
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    func makeUIView(context: Context) -> some UIView {
        mapView.delegate = context.coordinator
        mapView.isRotateEnabled = false
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        return mapView
    }
    
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        switch mapState {
        case .noInput:
            context.coordinator.clearMapViewAndRecenterOnUserLocation()
            context.coordinator.updateAnnotations()
            //print("DEBUG: Drivers in map view \(homeViewModel.drivers)")
            break
        case .searchingForLocation:
            break
        case .locationSelected:
            if let coordinate = homeViewModel.selectedDashDropLocation?.coordinate {
                context.coordinator.addAndSelectAnnotation(withCoordinate: coordinate)
                context.coordinator.configurePolyline(withDestinationCoordinate: coordinate)
                
            }
            break
        case .polylineAdded:
            break
        case .orderAccepted:
            guard let order = homeViewModel.order else { return }
            guard let driver = homeViewModel.currentUser, driver.accountType == .driver else { return }
            guard let route = homeViewModel.routeToPickupLocation else { return }
            
            context.coordinator.configurePolylineToPickupLocation(withRoute: route)
            context.coordinator.addAndSelectAnnotation(withCoordinate: order.pickupLocation.toCoordinate())
        default:
            break
        }
    }
    
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(parent: self)
    }
}

extension MapViewRepresentable {
    
    class MapCoordinator: NSObject, MKMapViewDelegate {
        var userIsInteracting = false
        
        //MARK: - Properties
        
        let parent: MapViewRepresentable
        var userLocationCoordinate: CLLocationCoordinate2D?
        var currentRegion: MKCoordinateRegion?
        
        //MARK: - Lifecycle
        
        init(parent: MapViewRepresentable) {
            self.parent = parent
            super.init()
        }
        
        //MARK: - MKMapViewDelegate
//        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
//            self.userLocationCoordinate = userLocation.coordinate
//            let region = MKCoordinateRegion(
//                center: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,
//                                               longitude: userLocation.coordinate.longitude),
//                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//            )
//
//            self.currentRegion = region
//
//            parent.mapView.setRegion(region, animated: false)
//        }
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            self.userLocationCoordinate = userLocation.coordinate
            
            // Calculate the distance between the new user location and the current map center
            let currentMapCenter = CLLocation(latitude: mapView.region.center.latitude, longitude: mapView.region.center.longitude)
            let newUserLocation = CLLocation(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
            
            let distance = currentMapCenter.distance(from: newUserLocation)
            
            // Update the map's region only if the user has moved more than 50 meters from the current map center
            if distance > 50 { // Threshold of 50 meters
                let region = MKCoordinateRegion(
                    center: userLocation.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                )
                
                self.currentRegion = region
                
                // Update the region without animation
                
                if self.userIsInteracting {
                    // Only recenter the map if the user is not currently interacting with it
                    parent.mapView.setRegion(region, animated: true)
                }
            }
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let polyline = MKPolylineRenderer(overlay: overlay)
            polyline.strokeColor = .systemBlue
            polyline.lineWidth = 6
            return polyline
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
            if let annotation = annotation as? DriverAnnotation {
                let view = MKAnnotationView(annotation: annotation, reuseIdentifier: "driver")
                view.image = UIImage(systemName: "car.fill")
                return view
            }
            
            return nil
        }
        
        //MARK: - Helpers
        
        func configurePolylineToPickupLocation(withRoute route: MKRoute) {
            self.parent.mapView.addOverlay(route.polyline)
            //self.parent.mapState = .polylineAdded
            let rect = self.parent.mapView.mapRectThatFits(route.polyline.boundingMapRect,
                                                           edgePadding: .init(top: 88,
                                                                              left: 32,
                                                                              bottom: 500,
                                                                              right: 32))
            self.parent.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
        
        func addAndSelectAnnotation(withCoordinate coordinate: CLLocationCoordinate2D) {
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            
            let anno = MKPointAnnotation()
            anno.coordinate = coordinate
            parent.mapView.addAnnotation(anno)
            parent.mapView.selectAnnotation(anno, animated: true)
        }
        
        func configurePolyline(withDestinationCoordinate coordinate: CLLocationCoordinate2D) {
            guard let userLocationCoordinate = self.userLocationCoordinate else { return }
            parent.homeViewModel.getDestinationRoute(from: userLocationCoordinate,
                                                         to: coordinate) { route in
                self.parent.mapView.addOverlay(route.polyline)
                self.parent.mapState = .polylineAdded
                let rect = self.parent.mapView.mapRectThatFits(route.polyline.boundingMapRect,
                                                               edgePadding: .init(top: 64,
                                                                                  left: 32,
                                                                                  bottom: 500,
                                                                                  right: 32))
                self.parent.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
            }
        }
        
        func clearMapViewAndRecenterOnUserLocation() {
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            parent.mapView.removeOverlays(parent.mapView.overlays)
            
            if let currentRegion = currentRegion {
                parent.mapView.setRegion(currentRegion, animated: true)
            }
            
        }
        
//        func addDriversToMap() {
//            // Remove existing driver annotations
//            let existingAnnotations = parent.mapView.annotations.filter { $0 is DriverAnnotation }
//            parent.mapView.removeAnnotations(existingAnnotations)
//            
//            // Check if the current user is a driver and logged in
//            if let currentUser = HomeViewModel.shared.currentUser, currentUser.accountType == .driver, let userLocation = LocationManager.shared.userLocation {
//                // Create and add annotation for the current driver
//                let driverAnnotation = DriverAnnotation(driver: currentUser)
//                driverAnnotation.coordinate = userLocation
//                DispatchQueue.main.async {
//                    self.parent.mapView.addAnnotation(driverAnnotation)
//                }
//            }
//        }
        
        @objc func updateAnnotations() {
            // Ensure UI updates are performed on the main thread
            DispatchQueue.main.async {
                // Remove existing driver annotations to reset the map's state
                let existingAnnotations = self.parent.mapView.annotations.filter { $0 is DriverAnnotation }
                self.parent.mapView.removeAnnotations(existingAnnotations)
                
                // Check if the current user is a driver and their location is known
                if let currentUser = HomeViewModel.shared.currentUser,
                   currentUser.accountType == .driver,
                   let userLocation = LocationManager.shared.userLocation {
                    
                    // Create an annotation for the driver's current location
                    let driverAnnotation = DriverAnnotation(driver: currentUser)
                    driverAnnotation.coordinate = userLocation
                    
                    // Add the driver's annotation to the map
                    self.parent.mapView.addAnnotation(driverAnnotation)
                }
            }
        }
    }
}
