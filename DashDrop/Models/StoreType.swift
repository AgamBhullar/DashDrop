//
//  StoreType.swift
//  DashDrop
//
//  Created by Agam Bhullar on 3/2/24.
//

import Foundation

enum StoreType: Int, CaseIterable, Identifiable {
    case ups
    case fedex
    case usps
    
    var id: Int { return rawValue }
    
    var description: String {
        switch self {
        case .ups: return "UPS"
        case .fedex: return "Fedex"
        case .usps: return "USPS"
        }
    }
    
    var imageName: String {
        switch self {
        case .ups: return "UPS"
        case .fedex: return "Fedex"
        case .usps: return "USPS"
        }
    }
    
    var baseFare: Double {
        switch self {
        case .ups: return 2
        case .fedex: return 2
        case .usps: return 2
        }
    }
    
    func computePrice(for distanceInMeters: Double) -> Double {
        let distanceInMiles = distanceInMeters / 1600
        
        switch self {
        case .ups: return distanceInMiles * 1.0 + baseFare
        case .fedex: return distanceInMiles * 1.0 + baseFare
        case .usps: return distanceInMiles * 1.0 + baseFare
        }
    }
}
