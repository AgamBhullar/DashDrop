//
//  SavedLocation.swift
//  DashDrop
//
//  Created by Agam Bhullar on 3/5/24.
//

import Firebase

struct SavedLocation: Codable {
    let title: String
    let address: String
    let coordinates: GeoPoint
}
