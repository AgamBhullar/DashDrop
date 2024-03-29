//
//  MapViewState.swift
//  DashDrop
//
//  Created by Agam Bhullar on 3/2/24.
//

import Foundation

enum MapViewState {
    case noInput
    case searchingForLocation
    case locationSelected
    case polylineAdded
    case orderRequested
    case orderRejected
    case orderAccepted
    case orderpredelivery
    case orderDelivered
    case orderCancelledByCustomer
    case orderCancelledByDriver
}
