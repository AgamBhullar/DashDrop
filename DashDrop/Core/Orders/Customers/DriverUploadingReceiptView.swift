//
//  DriverUploadingReceiptView.swift
//  DashDrop
//
//  Created by Agam Bhullar on 3/13/24.
//

import SwiftUI

struct DriverUploadingReceiptView: View {
    var body: some View {
        VStack {
            Capsule()
                .foregroundColor(Color(.systemGray5))
                .frame(width: 48, height: 6)
                .padding(.top, 8)
            
            HStack {
                    Text("The driver is uploading an image of the receipt.")
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

struct DriverUploadingReceiptView_Preview: PreviewProvider {
    static var previews: some View {
        DriverUploadingReceiptView()
    }
}

