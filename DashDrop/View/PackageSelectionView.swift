//
//  PackageSelectionView.swift
//  DashDrop
//
//  Created by Agam Bhullar on 2/13/24.
//

import SwiftUI

struct PackageSelectionView: View {
    var store: String
    @ObservedObject var orderDetails: OrderDetails 
    @State private var selectedPackageType: String? = nil
    @State private var quantity: Int = 1
    @State private var navigateToFinalStep = false
    
    let packageTypes = ["Box", "Soft Poly Bag", "Flat Envelope"]
    
    var body: some View {
        VStack {
            List(selection: $selectedPackageType) {
                ForEach(packageTypes, id: \.self) { packageType in
                    Text(packageType)
                        .padding()
                        .background(selectedPackageType == packageType ? Color.gray : Color.clear)
                        .cornerRadius(5)
                        .onTapGesture {
                            selectedPackageType = packageType
                            orderDetails.packageType = selectedPackageType
                            orderDetails.packageType = packageType
                        }
                }
            }
            
            Stepper("Quantity: \(quantity)", value: $quantity, in: 1...10)
                .padding()
                .onChange(of: quantity) { newValue in
                    orderDetails.quantity = newValue // Update the orderDetails object here
                }
            
            Button("Final Step") {
                navigateToFinalStep = true // This will trigger the NavigationLink
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            
            // Invisible NavigationLink to trigger programmatic navigation
            NavigationLink(destination: FinalStepView(store: store, packageType: selectedPackageType ?? "Box", quantity: quantity, orderDetails: orderDetails), isActive: $navigateToFinalStep) {
                EmptyView()
            }

        }
        .navigationTitle("Package Selection")
        .onAppear {
            orderDetails.store = store
        }
    }
}
