//
//  StoreSelectionView.swift
//  DashDrop
//
//  Created by Agam Bhullar on 2/13/24.
//

import SwiftUI

struct StoreSelectionView: View {
    @ObservedObject var orderDetails: OrderDetails
    
    var body: some View {
        //NavigationView {
            List {
                NavigationLink(destination: PackageSelectionView(store: "UPS", orderDetails: orderDetails)) { // Modify this line
                    Text("UPS")
                }
                NavigationLink(destination: PackageSelectionView(store: "Fedex", orderDetails: orderDetails)) { // Modify this line
                                Text("Fedex")
                            }
            }
            .navigationTitle("Select Store")
       // }
    }
}
