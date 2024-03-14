//
//  OrderView.swift
//  DashDrop
//
//  Created by Agam Bhullar on 3/13/24.
//

import SwiftUI

struct OrdersView: View {
    @ObservedObject var viewModel: OrdersViewModel
    
    

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
                        //receipt.receiptImageUrl
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
