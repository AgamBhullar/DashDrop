//
//  User.swift
//  DashDrop
//
//  Created by Agam Bhullar on 3/3/24.
//

import Firebase

enum AccountType: Int, Codable {
    case customer
    case driver
}

struct User: Codable {
    let fullname: String
    let email: String
    let uid: String
    var coordinates: GeoPoint
    var accountType: AccountType
    var homeLocation: SavedLocation?
    var workLocation: SavedLocation?
}
