//
//  OrderAcceptedView.swift
//  DashDrop
//
//  Created by Agam Bhullar on 3/7/24.
//

import SwiftUI

struct OrderAcceptedView: View {
    @EnvironmentObject var viewModel: HomeViewModel
    
    var body: some View {
        VStack {
            Capsule()
                .foregroundColor(Color(.systemGray5))
                .frame(width: 48, height: 6)
                .padding(.top, 8)
            
            if let order = viewModel.order {
                //pickup info view
                VStack {
                    HStack {
                        Text("Order Accepted. The driver will deliver your package to \(order.dropoffLocationName)")
                            .font(.headline)
                            .frame(height: 44)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                        
                        
                    }
                    .padding()
                    
                    Divider()
                }
                
                //Driver info view
                VStack {
                    HStack {
                        Image("ProfilePhoto")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(order.driverName)
                                .fontWeight(.bold)
                            
                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundColor(Color(.systemYellow))
                                    .imageScale(.small)
                                
                                Text("4.8")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
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
                        .cornerRadius(10)
                        
                    }
                    
                    Divider()
                }
                .padding()
            }
            
            Button {
                print("DEBUG: Cancel order")
            } label: {
                Text("CANCEL ORDER")
                    .fontWeight(.bold)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 50)
                    .background(.red)
                    .cornerRadius(10)
                    .foregroundColor(.white)
            }
        }
        .padding(.bottom, 24)
        .background(Color.theme.backgroundColor)
        .cornerRadius(16)
        .shadow(color: Color.theme.secondaryBackgroundColor, radius: 20)
    }
}

struct OrderAcceptedView_Preview: PreviewProvider {
    static var previews: some View {
        OrderAcceptedView()
    }
}
