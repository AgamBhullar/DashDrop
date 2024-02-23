//
//  OrderConfirmationView.swift
//  DashDrop
//
//  Created by Agam Bhullar on 2/13/24.
//

import SwiftUI

struct OrderConfirmationView: View {
    @EnvironmentObject var navigationController: NavigationController
    
    var body: some View {
        VStack {
            Spacer()
            Text("Your order has been successfully created!")
                .font(.title)
                .padding()
            Text("Thank you for using DashDrop.")
                .font(.headline)
            Spacer()
        }
        .navigationTitle("Order Confirmation")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true) // Hide the back button
        .navigationBarItems(trailing: Button("Done") {
            navigationController.shouldShowHomeView = false // Reset the flag
        })
    }
}
