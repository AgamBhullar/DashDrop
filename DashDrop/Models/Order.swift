//
//  Order.swift
//  DashDrop
//
//  Created by Agam Bhullar on 3/6/24.
//

import FirebaseFirestoreSwift
import Firebase

enum OrderState: Int, Codable {
    case requested
    case rejected
    case accepted
    case predeliver
    case delivered
    case customerCancelled
    case driverCancelled
}

struct Order: Identifiable, Codable {
    @DocumentID var orderId: String?
    let customerUid: String
    var driverUid: String
    let customerName: String
    let driverName: String
    let customerLocation: GeoPoint
    let driverLocation: GeoPoint
    let pickupLocationName: String
    let dropoffLocationName: String
    let pickupLocationAddress: String
    let deliveryLocationAddress: String
    let pickupLocation: GeoPoint
    let dropoffLocation: GeoPoint
    let tripCost: Double
    var distanceToCustomer: Double
    var travelTimeToCustomer: Int
    var state: OrderState
    var qrcodeImageUrl: String? 
    let selectedLabelOption: String
    let packageType: String
    var isCompletedForCustomer: Bool = false
    var isCompletedForDriver: Bool = false
    var isRejectedForCustomer: Bool = false
    var isRejectedForDriver: Bool = false
    @ServerTimestamp var creationDate: Timestamp?
    
    var id: String {
        return orderId ?? ""
    }
}

extension Order {
    var formattedCreationDate: String {
        creationDate?.dateValue().formatted() ?? "N/A"
    }
}
