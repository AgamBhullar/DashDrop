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
    @State private var isLoadingReceipt = false
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
                        .font(.system(size: 20))
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
                        isLoadingReceipt = true
                        viewModel.fetchReceipt(forOrder: order.id) {
                            DispatchQueue.main.async {
                                isLoadingReceipt = false
                                self.isShowingFullScreenImage = true
                            }
                        }
                    }) {
                        if isLoadingReceipt {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .frame(height: 56) // Matching the button height for alignment
                        }  else {
                            Text("VIEW RECEIPT")
                                .font(.headline)
                                .fontWeight(.bold)
                                .padding()
                                .frame(height: 56)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .disabled(isLoadingReceipt)
                    .sheet(isPresented: $isShowingFullScreenImage) {
                        if let receiptImageUrl = viewModel.receipt?.receiptImageUrl, let url = URL(string: receiptImageUrl) {
                            FullScreenImageView(url: url)
                        } else {
                            Text("Please refresh to view the image")
                        }
                    }
                    
                    Spacer()

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
