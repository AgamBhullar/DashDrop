//
//  SideMenuOptionViewModel.swift
//  DashDrop
//
//  Created by Agam Bhullar on 3/4/24.
//

import Foundation

enum SideMenuOptionViewModel: Int, CaseIterable, Identifiable {
    case orders
    //case wallet
    case settings
    //case messages
    
    var title: String {
        switch self {
        case .orders: return "Orders"
        //case .wallet: return "Wallet"
        case .settings: return "Settings"
        //case .messages: return "Messages"
        }
    }
    
    var imageName: String {
        switch self {
        case .orders: return "list.bullet.rectangle"
        //case .wallet: return "creditcard"
        case .settings: return "gear"
        //case .messages: return "bubble.left"
        }
    }
    
    var id: Int {
        return self.rawValue
    }
}
