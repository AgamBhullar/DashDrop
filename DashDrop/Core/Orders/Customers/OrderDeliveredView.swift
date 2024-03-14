//
//  OrderDeliveredView.swift
//  DashDrop
//
//  Created by Agam Bhullar on 3/12/24.
//

import SwiftUI
import Kingfisher

struct OrderDeliveredView: View {
    @EnvironmentObject var viewModel: HomeViewModel
    @State private var isShowingFullScreenImage = false
    @Environment(\.presentationMode) var presentationMode
    let order: Order


    var body: some View {
        VStack {
            Capsule()
                .foregroundColor(Color(.systemGray5))
                .frame(width: 48, height: 6)
                .padding(.top, 8)

            VStack {
                HStack {
                    Text("Order Completed! Refresh to view your return receipt below")
                        .fontWeight(.bold)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 25))
                        .padding()
                    
                    Spacer()
                    
//                    Button(action: {
//                        viewModel.fetchReceipt(forOrder: order.id)
//                    }) {
//                        Image(systemName: "arrow.clockwise")
//                            .font(.headline)
//                            .padding()
//                    }
                }
                .padding()

                Divider()

                HStack {
                    Button(action: {
                        viewModel.fetchReceipt(forOrder: order.id)
                        self.isShowingFullScreenImage = true
                    }) {
                        Text("VIEW RECEIPT")
                            .font(.headline)
                            .fontWeight(.bold)
                            .padding()
                            .frame(height: 56)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    //.disabled(viewModel.receipt?.receiptImageUrl == nil)
                    .sheet(isPresented: $isShowingFullScreenImage) {
                        if let receiptImageUrl = viewModel.receipt?.receiptImageUrl, let url = URL(string: receiptImageUrl) {
                            FullScreenImageView(url: url)
                        } else {
                            Text("Receipt image not available")
                        }
                    }
                    
                    Spacer()

                    Button {
                        presentationMode.wrappedValue.dismiss()
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
                .padding(.top)
                .padding(.horizontal)
                .padding(.bottom, 24)
            }
        }
        .padding(.bottom, 24)
        .background(Color.theme.backgroundColor)
        .cornerRadius(16)
        .shadow(color: Color.theme.secondaryBackgroundColor, radius: 20)
    }
}

// You might need to update the FullScreenImageView if it's defined elsewhere
//struct FullScreenImageView: View {
//    let url: URL
//
//    var body: some View {
//        KFImage(url)
//            .resizable()
//            .scaledToFit()
//    }
//}
