////
////  StoreSelectionView.swift
////  DashDrop
////
////  Created by Agam Bhullar on 2/13/24.
////
//
//import SwiftUI
//
//struct StoreSelectionView: View {
//    @ObservedObject var orderDetails: OrderDetails
//    //@EnvironmentObject var orderDetails: OrderDetails
//
//    
//    var body: some View {
//        
//        //NavigationView {
//            List {
//                
//                NavigationLink(destination: PackageSelectionView(store: "UPS", orderDetails: orderDetails)) { // Modify this line
//                    Text("UPS")
//                }
//                
//                NavigationLink(destination: PackageSelectionView(store: "Fedex", orderDetails: orderDetails)) { // Modify this line
//                                Text("Fedex")
//                            }
//                
//            }
//
//            .navigationTitle("Select Store")
//            .background {
//                        Image("Background2") // Use your background image
//                            .resizable() // Make sure the image can be resized to fill the background
//                            .scaledToFill() // Fill the entire background area
//                            .overlay(Color("CustomColor1").opacity(0.4)) // Apply a color overlay
//                            .edgesIgnoringSafeArea(.all) // Ensure it covers the whole screen including navigation bar area
//                    }
//       // }
//    }
//    
//}
//
//struct StoreSelectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        // Create a sample OrderDetails object for preview purposes
//        let sampleOrderDetails = OrderDetails()
//        // Optionally set some properties for the sample object if needed
//        sampleOrderDetails.fullAddress = "123 Main St"
//        sampleOrderDetails.packageType = "Box"
//        // etc.
//
//        return NavigationView {
//            StoreSelectionView(orderDetails: sampleOrderDetails)
//        }
//    }
//}

import SwiftUI

struct StoreSelectionView: View {
    @ObservedObject var orderDetails: OrderDetails

    var body: some View {
        List {
            NavigationLink(destination: PackageSelectionView(store: "UPS", orderDetails: orderDetails)) {
                HStack {
                    Image("UPSlogo") // Replace with your actual UPS logo image name
                        .resizable()
                        .scaledToFit()
                        .frame(height: 60) // Set an appropriate height for your logo
                    Text("UPS")
                        .font(.system(size: 29))
                        .bold()
                        
                }
            }

            NavigationLink(destination: PackageSelectionView(store: "Fedex", orderDetails: orderDetails)) {
                HStack {
                    Image("Fedexlogo") // Replace with your actual FedEx logo image name
                        .resizable()
                        .scaledToFit()
                        .frame(height: 70) // Set an appropriate height for your logo
                    Text("Fedex")
                        .font(.system(size: 29))
                        .bold()
                }
            }
        }
        .navigationTitle("Select Store")
        .background {
            Image("Background2")
                .resizable()
                .scaledToFill()
                .overlay(Color("CustomColor1").opacity(0.4))
                .edgesIgnoringSafeArea(.all)
        }
    }
}

struct StoreSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            StoreSelectionView(orderDetails: OrderDetails())
        }
    }
}
