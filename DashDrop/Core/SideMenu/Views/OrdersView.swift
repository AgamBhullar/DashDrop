//
//  OrdersView.swift
//  DashDrop
//
//  Created by Harpreet Basota on 3/12/24.
//

import SwiftUI

struct OrdersView: View {
    @ObservedObject var viewModel: OrdersViewModel // This view model will handle fetching orders from Firestore
    //let order: Order

    var body: some View {
            List(viewModel.orders) { order in
                Section("Order #: \(order.orderId ?? "")") {
                VStack(alignment: .leading, spacing: 10) {
                    Text(order.dropoffLocationName)
                    //Text("Order #: \(order.orderId ?? "")")
                    Text("Customer Name: \(order.customerName)")
                    Text("Driver Name: \(order.driverName)")
                    Text("Order Status: \(order.state)")
                    Button{
                        order.receiptImageUrl
                    } label: {
                        Text("View receipt")
                    }
                    
                    
                    // Add more details as needed
                }
                
                
            }
        }
            .navigationTitle("Order Details")
            .navigationBarTitleDisplayMode(.large)
        .onAppear {
            viewModel.fetchOrders()
        }
    }
}
