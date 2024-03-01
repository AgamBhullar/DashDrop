//
//  OrderDetails.swift
//  DashDrop
//
//  Created by Agam Bhullar on 2/14/24.
//
import Foundation
import MapKit
import SwiftUI

class OrderDetails: ObservableObject {
    //@Published var address: AddressResult?
    //static let shared = OrderDetails()
    
    @Published var store: String?
    @Published var packageType: String?
    @Published var quantity: Int = 1
    @Published var qrCodeImage: UIImage?
    @Published var prePaidLabelChosen: Bool = false
    @Published var fullAddress: String?
    @Published var qrCodeImageURL: String?
    //private init() {} // Make init private to enforce singleton usage
    
    func updateAddress(with selection: MKLocalSearchCompletion) {
        // Convert selection to a full address string
        // This could involve another MKLocalSearch request to resolve the completion to a placemark
        // and then constructing a full address string from the placemark's properties
    }
}
