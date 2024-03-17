//
//  LocationManager.swift
//  DashDrop
//
//  Created by Agam Bhullar on 3/1/24.
//

import CoreLocation
import Firebase

class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    static let shared = LocationManager()
    @Published var userLocation: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}

//extension LocationManager: CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:
//        [CLLocation]) {
//        guard let location = locations.first else { return }
//        self.userLocation = location.coordinate
//        //locationManager.stopUpdatingLocation()
//    }
//}


extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        self.userLocation = location.coordinate
        
        // Check if the user is a driver and update their location in Firestore
        if let currentUser = HomeViewModel.shared.currentUser, currentUser.accountType == .driver {
            updateDriverLocationInFirestore(user: currentUser, location: location.coordinate)
        }
    }
    
    private func updateDriverLocationInFirestore(user: User, location: CLLocationCoordinate2D) {
        let geoPoint = GeoPoint(latitude: location.latitude, longitude: location.longitude)
        let firestore = Firestore.firestore()
        firestore.collection("users").document(user.uid).updateData(["coordinates": geoPoint]) { error in
            if let error = error {
                print("Error updating driver location: \(error.localizedDescription)")
            } else {
                print("Driver location updated successfully.")
            }
        }
    }
}


