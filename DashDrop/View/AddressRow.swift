//
//  AddressRow.swift
//  DashDrop
//
//  Created by Agam Bhullar on 2/13/24.
//

import SwiftUI

struct AddressRow: View {
    
    let address: AddressResult
    @ObservedObject var orderDetails: OrderDetails
    @ObservedObject var mapViewModel: MapViewModel
    
    var body: some View {
        NavigationLink {
            MapView(address: address, orderDetails: orderDetails)
        } label: {
            VStack(alignment: .leading) {
                Text(address.title)
                Text(address.subtitle)
                    .font(.caption)
            }
        }
        .padding(.bottom, 2)
        .onTapGesture {
            mapViewModel.getFullAddress(from: address) { fullAddress in
                DispatchQueue.main.async {
                    orderDetails.fullAddress = fullAddress
                }
            }
        }
    }
}
