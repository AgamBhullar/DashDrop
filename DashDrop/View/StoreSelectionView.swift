//
//  StoreSelectionView.swift
//  DashDrop
//
//  Created by Agam Bhullar on 2/13/24.
//

import SwiftUI

struct StoreSelectionView: View {
    var body: some View {
        //NavigationView {
            List {
                NavigationLink(destination: PackageSelectionView(store: "UPS")) {
                    Text("UPS")
                }
                NavigationLink(destination: PackageSelectionView(store: "FedEx")) {
                    Text("FedEx")
                }
            }
            .navigationTitle("Select Store")
       // }
    }
}
