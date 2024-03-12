//
//  PackageType.swift
//  DashDrop
//
//  Created by Agam Bhullar on 3/2/24.
//

import Foundation

enum PackageType: Int, CaseIterable, Identifiable {
    case box
    case softPolyBag
    case flatEnvelope
    
    
    var id: Int { return rawValue }
    
    var description: String {
        switch self {
        case .box: return "Box"
        case .softPolyBag: return "Soft Poly Bag"
        case .flatEnvelope: return "Flat Envelope"
        }
    }
    
    var imageName: String {
        switch self {
        case .box: return "Box"
        case .softPolyBag: return "SoftPolyBag"
        case .flatEnvelope: return "Envelope"
        }
    }
    
    var baseFare: Double {
        switch self {
        case .box: return 2
        case .softPolyBag: return 2
        case .flatEnvelope: return 2
        }
    }
    
    func computePrice(for distanceInMeters: Double) -> Double {
        let distanceInMiles = distanceInMeters / 1600
        
        switch self {
        case .box: return distanceInMiles * 1.0 + baseFare
        case .softPolyBag: return distanceInMiles * 1.0 + baseFare
        case .flatEnvelope: return distanceInMiles * 1.0 + baseFare
        }
    }
}

extension PackageType {
    init?(description: String) {
        switch description {
        case "Box": self = .box
        case "Soft Poly Bag": self = .softPolyBag
        case "Flat Envelope": self = .flatEnvelope
        default: return nil
        }
    }
}
