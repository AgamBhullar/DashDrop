//
//  GeoPoint.swift
//  DashDrop
//
//  Created by Agam Bhullar on 3/7/24.
//

import Firebase
import CoreLocation

extension GeoPoint {
    func toCoordinate() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
}
