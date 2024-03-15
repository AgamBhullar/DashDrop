//
//  OrderRejectedView.swift
//  DashDrop
//
//  Created by Agam Bhullar on 3/14/24.
//

import SwiftUI

struct OrderRejectedView: View {
    let order: Order
    @EnvironmentObject var viewModel: HomeViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Capsule()
                .foregroundColor(Color(.systemGray5))
                .frame(width: 48, height: 6)
                .padding(.top, 8)
            
            HStack {
                    Text("The order was rejected by the driver. Please create a new order.")
                        .font(.headline)
                    
//                    Text("Finding a driver.. ")
//                        .font(.headline)
            
                .padding()
                Button {
                    if let orderId = order.orderId {
                            viewModel.markOrderAsCompletedForCustomer(orderId: orderId)
                            viewModel.resetOrderAndUserState()
                        }
                        self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("DONE")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding()
                        .frame(width: (UIScreen.main.bounds.width / 2) - 32, height: 56)
                        .background(Color(.systemBlue))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                }
                
                
            }
            .padding(.bottom, 24)
        }
        .background(Color.theme.backgroundColor)
        .cornerRadius(16)
        .shadow(color: Color.theme.secondaryBackgroundColor, radius: 20)
    }
}

//struct OrderRejectedView_Preview: PreviewProvider {
//    static var previews: some View {
//        OrderRejectedView(order: dev.mockOrder, order: dev.mockUser)
//    }



