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
    @Published var address: AddressResult?
    @Published var store: String?
    @Published var packageType: String?
    @Published var quantity: Int = 1
    @Published var qrCodeImage: UIImage?
    @Published var prePaidLabelChosen: Bool = false
    @Published var fullAddress: String?
    @Published var qrCodeImageURL: String?
}
