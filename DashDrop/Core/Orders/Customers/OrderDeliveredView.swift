//
//  OrderDeliveredView.swift
//  DashDrop
//
//  Created by Agam Bhullar on 3/12/24.
//

import SwiftUI

struct OrderDeliveredView: View {
    @EnvironmentObject var viewModel: HomeViewModel
    
    var body: some View {
        VStack {
            
            Capsule()
                .foregroundColor(Color(.systemGray5))
                .frame(width: 48, height: 6)
                .padding(.top, 8)
            
            VStack {
                HStack {
                    Text("The Driver is uploading the return receipt photo")
                        //.font(.headline)
                       
                        .fontWeight(.bold)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 25))
                        //.frame(height: 44)
                    
                }
                .padding()
                
                Divider()
                
                HStack {
                    Button {
                        print("DEBUG: Place for photo")
                    } label: {
                        Text("VIEW RECEIPT")
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
                        viewModel.acceptOrder()
                    } label: {
                        Text("DONE")
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
        }
        .padding(.bottom, 24)
        .background(Color.theme.backgroundColor)
        .cornerRadius(16)
        .shadow(color: Color.theme.secondaryBackgroundColor, radius: 20)    }
}

#Preview {
    OrderDeliveredView()
}
