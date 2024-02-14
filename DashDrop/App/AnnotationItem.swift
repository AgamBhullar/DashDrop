//
//  AnnotationItem.swift
//  DashDrop
//
//  Created by Agam Bhullar on 2/13/24.
//

import Foundation
import MapKit

struct AnnotationItem: Identifiable {
    let id = UUID()
    let latitude: Double
    let longitude: Double
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
