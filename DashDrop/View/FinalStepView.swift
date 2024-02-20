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
    @ObservedObject var orderDetails: OrderDetails
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
                    orderDetails.prePaidLabelChosen.toggle()
                    showingAlert = true
                }
                .alert("Please make sure to properly install the label on the package before placing it for delivery.", isPresented: $showingAlert) {
                    Button("OK", role: .cancel) { }
                }
                Spacer()
                Button("Create Order") {
                    if showingImagePicker {
                        // If showingImagePicker is true, it implies the user intends to upload an image.
                        // The ImagePicker's onImageUploaded closure should handle setting the qrCodeImageURL
                        // and then call sendOrderDetails(), ensuring order details are sent after image upload.
                        
                        // Trigger the ImagePicker to show.
                        showingImagePicker = true
                    } else {
                        // If there's no need for an image upload, send order details immediately.
                        sendOrderDetails()
                    }
                    
                    // Navigate to confirmation view or set orderCreated to true if that's handled elsewhere.
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
                ImagePicker(selectedImage: $image, onImageUploaded: { imageUrl in
                    print("Image URL for order details: \(imageUrl)")
                    self.orderDetails.qrCodeImageURL = imageUrl
                    self.sendOrderDetails() // Call sendOrderDetails here after image URL is set
                })
            }
        .padding()
        .navigationTitle("Final Step")
    }
    
    private func sendOrderDetails() {
        guard let webhookURL = URL(string: "https://hooks.zapier.com/hooks/catch/17935422/3l7ian2/") else {
            print("Invalid webhook URL")
            return
        }

        var request = URLRequest(url: webhookURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        // Assuming `orderDetails` is an instance of `OrderDetails` passed to this view
        let qrCodeURL = orderDetails.qrCodeImage != nil ? "URL to the uploaded QR code image" : "No QR Code provided"
        //let address = orderDetails.address?.title ?? "No address provided" // Make sure to handle address appropriately
        let fullAddress = orderDetails.fullAddress ?? "No address provided"

        print("Full Address before sending: \(orderDetails.fullAddress ?? "No address")")
        let orderInfo: [String: Any] = [
            "address": orderDetails.fullAddress ?? "No address provided",
            "store": orderDetails.store ?? "No store selected",
            "packageType": orderDetails.packageType ?? "No package type selected",
            "quantity": orderDetails.quantity,
            "qrCodeURL": orderDetails.qrCodeImageURL ?? "No QR Code provided",
            "prePaidLabelChosen": orderDetails.prePaidLabelChosen ? "Yes" : "No"
        ]
        
        print("Sending Order Info to Zapier: \(orderInfo)") // Add this line

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: orderInfo, options: [])
            request.httpBody = jsonData
        } catch {
            print("Error serializing order data: \(error.localizedDescription)")
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let _ = data, error == nil else {
                print("Error sending order details: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            // Handle successful POST request if needed
            // For example, navigate to the confirmation view
        }
        task.resume()
    }

}
