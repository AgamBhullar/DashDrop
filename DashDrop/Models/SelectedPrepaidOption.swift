//
//  SelectedPrepaidOption.swift
//  DashDrop
//
//  Created by Agam Bhullar on 3/8/24.
//

import Foundation

enum SelectedPrepaidOption: Int, CaseIterable, Identifiable {
    case qrcode
    case selectedLabel

    var id: Int { return rawValue }
    
    var heading: String {
        switch self {
        case .qrcode: return "I have a QR code"
        case .selectedLabel: return "I have a shipping label"
        }
    }
    
    var subHeading: String {
        switch self {
        case .qrcode: return "Prior to confirming order, upload a QR code."
        case .selectedLabel: return "Prior to confirming order, affix the label on your sealed package."
        }
    }
    
    var nameImage: String {
        switch self {
        case .qrcode: return "QRCode"
        case .selectedLabel: return "PrepaidLabel"
        }
    }
}
