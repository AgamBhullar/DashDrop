//
//  OrderView.swift
//  DashDrop
//
//  Created by Agam Bhullar on 3/13/24.
//

import SwiftUI

struct OrdersView: View {
    @ObservedObject var viewModel: OrdersViewModel
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        VStack {
            Text("Order Details")
                .font(.largeTitle)
                .bold()
                .padding()
            
            List(viewModel.completedOrders) { order in
                VStack(alignment: .leading) {
                    Text("Order ID: \(order.orderId ?? "N/A")")
                    Text("Driver Name: \(order.driverName)")
                    Text("Customer Name: \(order.customerName)")
                    Text("Pickup Location: \(order.pickupLocationName)")
                    Text("Dropoff Location: \(order.dropoffLocationName)")
                    Text("Total Cost: \(order.tripCost, specifier: "%.2f")")
                    Button("VIEW RECEIPT") {
                        viewModel.fetchReceipt(forOrder: order.id)
                    }
                }
            }
            .onAppear {
                if let user = authViewModel.currentUser {
                    viewModel.fetchCompletedOrders(forUser: user)
                }
            }
            .sheet(item: $viewModel.selectedReceipt) { receipt in
                if let url = URL(string: receipt.receiptImageUrl ?? "") {
                    FullScreenImageView(url: url)
                } else {
                    Text("Receipt image not available")
                }
            }
        }
        .background(Color.theme.backgroundColor)
    }
}







