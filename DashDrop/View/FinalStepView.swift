//
//  FinalStepView.swift
//  DashDrop
//
//  Created by Agam Bhullar on 2/13/24.
//

import SwiftUI

struct FinalStepView: View {
    var store: String
    var packageType: String
    var quantity: Int
    @State private var showingAlert = false
    @State private var uploadQRCode = false // Assume this will trigger another view for QR code upload
    @State private var showingImagePicker = false
    @State private var image: UIImage?
    @State private var orderCreated = false
    @State private var navigateToConfirmation = false
    
    var body: some View {
            VStack(spacing: 20) {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                }
                
                Button("Return QR Code") {
                    showingImagePicker = true
                    uploadQRCode = true
                }
                Button("Pre Paid Label") {
                    showingAlert = true
                }
                .alert("Please make sure to properly install the label on the package before placing it for delivery.", isPresented: $showingAlert) {
                    Button("OK", role: .cancel) { }
                }
                Spacer()
                Button("Create Order") {
                    // Handle order creation logic here
                    orderCreated = true
                    navigateToConfirmation = true
                }
                
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(8)
                
                NavigationLink(destination: OrderConfirmationView(), isActive: $navigateToConfirmation) { EmptyView() }
            }
        
//        .sheet(isPresented: $orderCreated) {
//            OrderConfirmationView()
//        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImage: $image)
        }
        .padding()
        .navigationTitle("Final Step")
    }
}
