//
//  DashDropLocation.swift
//  DashDrop
//
//  Created by Agam Bhullar on 3/2/24.
//

import CoreLocation

struct DashDropLocation: Identifiable {
    let id = NSUUID().uuidString
    let title: String
    let coordinate: CLLocationCoordinate2D
}
