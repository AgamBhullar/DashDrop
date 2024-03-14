//
//  PickupPassengerView.swift
//  DashDrop
//
//  Created by Agam Bhullar on 3/11/24.
//

import SwiftUI
import Kingfisher

struct PickupPackageView: View {
    let order: Order
    @State private var isShowingFullScreenImage = false
    @EnvironmentObject var viewModel: HomeViewModel
    
    var body: some View {
        VStack {
            Capsule()
                .foregroundColor(Color(.systemGray5))
                .frame(width: 48, height: 6)
                .padding(.top, 8)
            
            //would you like to pickup view
            VStack {
                HStack {
                    VStack {
                        Text("Dropoff The \(order.packageType) At \(order.dropoffLocationName)")
                            .font(.headline)
                            .fontWeight(.bold)
//                            .lineLimit(2)
//                            .multilineTextAlignment(.leading)
//                            .frame(height: 44)
                        
                        Text(order.deliveryLocationAddress)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
//                            .lineLimit(2)
//                            .multilineTextAlignment(.leading)
//                            .frame(height: 44)
                        
                    }
                    Spacer()
                    
                    VStack {
                        Text("\(order.travelTimeToCustomer)")
                            .bold()
                        
                        Text("min")
                            .bold()
                    }
                    .frame(width: 56, height: 56)
                    .foregroundColor(.white)
                    .background(Color(.systemBlue))
                    .cornerRadius(8)
                }
                .padding()
                
                Divider()
            }
            
            // Order View
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        if let qrcodeImageUrl = order.qrcodeImageUrl, let url = URL(string: qrcodeImageUrl) {
                            Button(action: {
                                viewModel.refreshOrder()
                                self.isShowingFullScreenImage = true
                            }) {
                                Text("VIEW QR CODE")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .padding()
                                    .frame(height: 56)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            .sheet(isPresented: $isShowingFullScreenImage) {
                                FullScreenImageView(url: url)
                            }
                        } else {
                            Text(order.selectedLabelOption)
                                .font(.headline)
                        }
                    }
                   // Spacer()
                    
                    VStack() {
                        
                        
                        // Attempt to initialize a PackageType from the order's packageType description
                        if let packageType = PackageType(description: order.packageType) {
                            // If successful, display the image associated with this package type
                            Image(packageType.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100) // Adjust size as needed
                                //.padding(.bottom, 10) // Adjust padding as needed
                            
                            Text(order.packageType)
                                .font(.headline)
                                .fontWeight(.semibold)
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
        
                        }
                    }
                    //.padding(.horizontal, 40)
                    
                    VStack(spacing: 6) {
                        Text("Pay")
                       
                        
                        Text("\(order.tripCost.toCurrency())")
                            .font(.system(size: 24, weight: .semibold))
                    }
                    
                }
                
                Divider()
            }
           // .padding()
            
            HStack {
                Button {
                    viewModel.cancelOrderAsDriver()
                } label: {
                    Text("CANCEL ORDER")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding()
                        .frame(width: (UIScreen.main.bounds.width / 2) - 32,
                               height: 56)
                        .background(Color(.systemRed))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Button {
                    viewModel.preDelivery()
                } label: {
                    Text("DELIVER ORDER")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding()
                        .frame(width: (UIScreen.main.bounds.width / 2) - 32,
                               height: 56)
                        .background(Color(.systemBlue))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                }

            }
            .padding(.top)
            .padding(.horizontal)
            .padding(.bottom, 24)
        }
        .padding(.bottom, 24)
        .background(Color.theme.backgroundColor)
        .cornerRadius(16)
        .shadow(color: Color.theme.secondaryBackgroundColor, radius: 20)
    }
    
}


struct PickupPackageView_Previews: PreviewProvider {
    static var previews: some View {
        PickupPackageView(order: dev.mockOrder)
    }
}


