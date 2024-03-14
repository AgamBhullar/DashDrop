//
//  DeveloperPreview.swift
//  DashDrop
//
//  Created by Agam Bhullar on 3/5/24.
//

import SwiftUI
import Firebase

extension PreviewProvider {
    static var dev: DeveloperPreview {
        return DeveloperPreview.shared
    }
}

class DeveloperPreview {
    static let shared = DeveloperPreview()
    
    let mockOrder = Order(
        customerUid: NSUUID().uuidString,
        driverUid: NSUUID().uuidString,
        customerName: "Agam Bhullar",
        driverName: "John Doe",
        customerLocation: .init(latitude: 38.55106, longitude: -121.728798),
        driverLocation: .init(latitude: 38.546774, longitude: -121.7712501),
        pickupLocationName: "La Rue",
        dropoffLocationName: "UPS",
        pickupLocationAddress: "184 Horizon St, Davis CA",
        deliveryLocationAddress: "2916 La Rue Driver, Davis CA",
        pickupLocation: .init(latitude: 38.55106, longitude: -121.728798),
        dropoffLocation: .init(latitude: 38.046774, longitude: -121.9912501),
        tripCost: 5.0,
        distanceToCustomer: 1000,
        travelTimeToCustomer: 24,
        state: .rejected,
        selectedLabelOption: "The customer chose the prepaid label option.",
        packageType: "Flat Envelope"
    )
    
    
    let mockUser = User(
        fullname: "Agam Bhullar",
        email: "agambhullar313@gmail.com",
        uid: NSUUID().uuidString, 
        coordinates: GeoPoint(latitude: 38.5458285, longitude: -121.7653148),
        accountType: .customer,
        homeLocation: nil,
        workLocation: nil
    )
    
}
