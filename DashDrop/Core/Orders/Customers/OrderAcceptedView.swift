//
//  OrderAcceptedView.swift
//  DashDrop
//
//  Created by Agam Bhullar on 3/7/24.
//

import SwiftUI

struct OrderAcceptedView: View {
    private let user: User
    @EnvironmentObject var viewModel: HomeViewModel
    
    init(user: User) {
        self.user = user
    }
    
    var body: some View {
        if let user = viewModel.currentUser {
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
//                            Text(user.initials)
//                                .font(.title)
//                                .fontWeight(.semibold)
//                                .foregroundColor(.white)
//                                .frame(width: 72, height: 72)
//                                .background(Color(.systemGray3))
//                                .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Driver:")
                                    .fontWeight(.bold)
                                Text(order.driverName)
                                    
                                
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
                    viewModel.cancelOrderAsCustomer()
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
}

struct OrderAcceptedView_Preview: PreviewProvider {
    static var previews: some View {
        OrderAcceptedView(user: dev.mockUser)
    }
}
