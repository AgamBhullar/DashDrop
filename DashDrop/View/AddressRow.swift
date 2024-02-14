//
//  AddressRow.swift
//  DashDrop
//
//  Created by Agam Bhullar on 2/13/24.
//

import SwiftUI

struct AddressRow: View {
    
    let address: AddressResult
    
    var body: some View {
        NavigationLink {
            MapView(address: address)
        } label: {
            VStack(alignment: .leading) {
                Text(address.title)
                Text(address.subtitle)
                    .font(.caption)
            }
        }
        .padding(.bottom, 2)
    }
}
