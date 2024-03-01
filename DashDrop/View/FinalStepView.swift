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
    
    @EnvironmentObject var appData: AppData
    
    @ObservedObject var orderDetails: OrderDetails
    @State private var showingAlert = false
    @State private var uploadQRCode = false // Assume this will trigger another view for QR code upload
    @State private var showingImagePicker = false
    @State private var image: UIImage?
    @State private var orderCreated = false
    @State private var navigateToConfirmation = false
    @State private var showAlertForOrderCreation = false
    
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
                if self.orderDetails.prePaidLabelChosen || self.image != nil {
                    self.sendOrderDetails()
                    self.appData.lastOrderDetails = self.orderDetails
                    self.navigateToConfirmation = true
                } else {
                    self.showAlertForOrderCreation = true
                }
                
//                            orderDetails.store = store
//                            orderDetails.packageType = packageType
//                            orderDetails.quantity = quantity
                            // Assuming you handle QR Code or Pre Paid Label choice here as well

                            // Navigation or confirmation logic here
                            //navigateToConfirmation = true
            }
            
                
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(8)
                .alert(isPresented: $showAlertForOrderCreation) {
                    Alert(title: Text("Error"), message: Text("Please upload a QR Code or select Pre Paid Label."), dismissButton: .default(Text("OK")))
                }
                
            NavigationLink(destination: OrderConfirmationView(lastOrderDetails: orderDetails), isActive: $navigateToConfirmation) { EmptyView() }
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



//import SwiftUI
//
//struct FinalStepView: View {
//    var store: String
//    var packageType: String
//    var quantity: Int
//    //@ObservedObject var orderDetails: OrderDetails
//    @EnvironmentObject var orderDetails: OrderDetails
//    @State private var showingAlert = false
//    @State private var uploadQRCode = false // Assume this will trigger another view for QR code upload
//    @State private var showingImagePicker = false
//    @State private var image: UIImage?
//    @State private var orderCreated = false
//    @State private var navigateToConfirmation = false
//    @State private var showAlertForOrderCreation = false
//    
//    var body: some View {
//        VStack(spacing: 20) {
//            if let image = image {
//                Image(uiImage: image)
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 200, height: 200)
//            }
//            
//            Button("Return QR Code") {
//                showingImagePicker = true
//                uploadQRCode = true
//            }
//            Button("Pre Paid Label") {
//                orderDetails.prePaidLabelChosen.toggle()
//                showingAlert = true
//            }
//            .alert("Please make sure to properly install the label on the package before placing it for delivery.", isPresented: $showingAlert) {
//                Button("OK", role: .cancel) { }
//            }
//            Spacer()
//            Button("Create Order") {
//                if self.orderDetails.prePaidLabelChosen || self.image != nil {
//                    // Notice the completion handler being passed as an argument here
//                    self.sendOrderDetails { success in
//                        DispatchQueue.main.async {
//                            if success {
//                                // Navigation or confirmation logic here
//                                self.navigateToConfirmation = true
//                            } else {
//                                // Handle the failure case, perhaps by showing an error message to the user
//                                self.showAlertForOrderCreation = true
//                            }
//                        }
//                    }
//                } else {
//                    self.showAlertForOrderCreation = true
//                }
//            }
//
//
//            
//                
//                .padding()
//                .background(Color.green)
//                .foregroundColor(.white)
//                .cornerRadius(8)
//                .alert(isPresented: $showAlertForOrderCreation) {
//                    Alert(title: Text("Error"), message: Text("Please upload a QR Code or select Pre Paid Label."), dismissButton: .default(Text("OK")))
//                }
//                
//                NavigationLink(destination: OrderInformationView(), isActive: $navigateToConfirmation) { EmptyView() }
//            }
//        
////        .sheet(isPresented: $orderCreated) {
////            OrderConfirmationView()
////        }
//        .sheet(isPresented: $showingImagePicker) {
//            ImagePicker(selectedImage: $image, onImageUploaded: { imageUrl in
//                print("Image URL for order details: \(imageUrl)")
//                self.orderDetails.qrCodeImageURL = imageUrl
//                // Updated to include a completion handler
//                self.sendOrderDetails { success in
//                    DispatchQueue.main.async {
//                        if success {
//                            // Handle success, such as confirming the QR code was processed
//                            print("QR Code successfully uploaded and order details sent.")
//                        } else {
//                            // Handle failure, such as showing an error message
//                            print("Failed to upload QR Code and send order details.")
//                        }
//                    }
//                }
//            })
//        }
//
//        .padding()
//        .navigationTitle("Final Step")
//        
//    }
//    
//    private func sendOrderDetails(completion: @escaping (Bool) -> Void) {
//        guard let webhookURL = URL(string: "https://hooks.zapier.com/hooks/catch/17935422/3l7ian2/") else {
//            print("Invalid webhook URL")
//            completion(false)
//            return
//        }
//
//        var request = URLRequest(url: webhookURL)
//        request.httpMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        let orderInfo: [String: Any] = [
//            "address": orderDetails.fullAddress ?? "No address provided",
//            "store": orderDetails.store ?? "No store selected",
//            "packageType": orderDetails.packageType ?? "No package type selected",
//            "quantity": orderDetails.quantity,
//            "qrCodeURL": orderDetails.qrCodeImageURL ?? "No QR Code provided",
//            "prePaidLabelChosen": orderDetails.prePaidLabelChosen ? "Yes" : "No"
//        ]
//        
//        do {
//            let jsonData = try JSONSerialization.data(withJSONObject: orderInfo, options: [])
//            request.httpBody = jsonData
//        } catch {
//            print("Error serializing order data: \(error.localizedDescription)")
//            completion(false)
//            return
//        }
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, error == nil else {
//                print("Error sending order details: \(error?.localizedDescription ?? "Unknown error")")
//                completion(false)
//                return
//            }
//            completion(true)
//        }
//        task.resume()
//    }
//
//}
