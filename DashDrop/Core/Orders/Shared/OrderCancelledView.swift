//
//  OrderCancelledView.swift
//  DashDrop
//
//  Created by Agam Bhullar on 3/22/24.
//

import SwiftUI

struct OrderCancelledView: View {
    @EnvironmentObject var viewModel: HomeViewModel
    var body: some View {
        VStack {
            Capsule()
                .foregroundColor(Color(.systemGray5))
                .frame(width: 48, height: 6)
                .padding(.top, 8)
            
            Text(viewModel.OrderCancelledMessage)
                .padding(.vertical)
            
            Button {
                guard let user = viewModel.currentUser else { return }
                guard let order = viewModel.order else { return }
                
                if user.accountType == .customer {
                    if order.state == .driverCancelled {
                        viewModel.deleteOrder()
                    } else if order.state == .customerCancelled {
                        viewModel.order = nil
                    }
                } else {
                    if order.state == .customerCancelled {
                        viewModel.deleteOrder()
                    } else if order.state == .driverCancelled {
                        viewModel.order = nil
                    }
                }
            } label: {
                Text("OK")
                    .font(.headline)
                    .fontWeight(.bold)
                    .frame(width: (UIScreen.main.bounds.width / 2) - 32,
                           height: 56)
                    .background(Color(.systemBlue))
                    .cornerRadius(10)
                    .foregroundColor(.white)
            }
        }
        .padding(.bottom, 24)
        .frame(maxWidth: .infinity)
        .background(Color.theme.backgroundColor)
        .cornerRadius(16)
        .shadow(color: Color.theme.secondaryBackgroundColor, radius: 20)
    }
}

#Preview {
    OrderCancelledView()
}
