//
//  DriverDeliveredView.swift
//  DashDrop
//
//  Created by Agam Bhullar on 3/12/24.
//

import SwiftUI
import FirebaseStorage

struct DriverDeliveredView: View {
    @EnvironmentObject var viewModel: HomeViewModel // Assuming HomeViewModel contains the upload function
    let order: Order
    @State private var showImagePicker = false
    @State private var receiptImage: UIImage?
    @State private var uploadButtonEnabled = false

    var body: some View {
        VStack {
            Capsule()
                .foregroundColor(Color(.systemGray5))
                .frame(width: 48, height: 6)
                .padding(.top, 8)
            
            Text("Upload a photo of the receipt for the customer")
                .fontWeight(.bold)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .font(.system(size: 25))
                .padding()
            
            Divider()
            
            Button {
                showImagePicker = true
            } label: {
                Text(receiptImage == nil ? "UPLOAD" : "CHANGE PHOTO")
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding()
                    .frame(width: UIScreen.main.bounds.width - 100, height: 50)
                    .background(Color(.systemBlue))
                    .cornerRadius(10)
                    .foregroundColor(.white)
            }
            .padding()
            .sheet(isPresented: $showImagePicker, onDismiss: {
                uploadButtonEnabled = receiptImage != nil
            }) {
                ImagePicker(selectedImage: $receiptImage)
            }

            if let receiptImage = receiptImage {
                Image(uiImage: receiptImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350, height: 350)
                    .cornerRadius(12)
            }

            if uploadButtonEnabled {
                Button {
                    guard let receiptImage = receiptImage else { return }
                    viewModel.uploadReceiptImage(forOrder: order.id, image: receiptImage)
                        // Handle completion, e.g., show a success message or update the UI
                    
                } label: {
                    Text("CONFIRM DELIVERY")
                        .fontWeight(.bold)
                        .frame(width: UIScreen.main.bounds.width - 64, height: 50)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
        }
        .padding(.bottom, 24)
        .background(Color.theme.backgroundColor)
        .cornerRadius(16)
        .shadow(color: Color.theme.secondaryBackgroundColor, radius: 20)
    }
}

struct DriverDeliveredView_Previews: PreviewProvider {
    static var previews: some View {
        DriverDeliveredView(order: dev.mockOrder)
    }
}
