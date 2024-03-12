//
//  OrderLoadingView.swift
//  DashDrop
//
//  Created by Agam Bhullar on 3/7/24.
//

import SwiftUI

struct OrderLoadingView: View {
    var body: some View {
        VStack {
            Capsule()
                .foregroundColor(Color(.systemGray5))
                .frame(width: 48, height: 6)
                .padding(.top, 8)
            
            HStack {
                    Text("Order Requested")
                        .font(.headline)
                    
//                    Text("Finding a driver.. ")
//                        .font(.headline)
            
                .padding()
                
                Spacer()
                
                Spinner(lineWidth: 6, height: 44, width: 44)
                    .padding()
            }
            .padding(.bottom, 24)
        }
        .background(Color.theme.backgroundColor)
        .cornerRadius(16)
        .shadow(color: Color.theme.secondaryBackgroundColor, radius: 20)
    }
}

struct OrderLoadingView_Preview: PreviewProvider {
    static var previews: some View {
        OrderLoadingView()
    }
}
