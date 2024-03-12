//
//  SelectStoreView.swift
//  DashDrop
//
//  Created by Agam Bhullar on 3/2/24.
//

import SwiftUI

struct OrderRequestView: View {
    //@State private var selectedStoreType: StoreType = .ups
    @State private var selectedPackageType: PackageType = .box
    @State private var selectedQRCodeImage: UIImage?
    @State private var isPrepaidOptionSelected = false
    @State private var isPackageTypeSelected = false
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    var body: some View {
        VStack {
            Capsule()
                .foregroundColor(Color(.systemGray5))
                .frame(width: 48, height: 6)
                .padding(.top, 8)
            
            //order info view
            HStack {
                VStack {
                    Circle()
                        .fill(Color(.systemGray3))
                        .frame(width: 8, height: 8)
                    
                    Rectangle()
                        .fill(Color(.systemGray3))
                        .frame(width: 1, height: 32)
                    
                    Rectangle()
                        .fill(.red)
                        .frame(width: 8, height: 8)
                }
                
                VStack(alignment: .leading, spacing: 24) {
                    HStack {
                        Text("Current location")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        Text(homeViewModel.pickupTime ?? "")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.gray)
                    }
                    .padding(.bottom, 10)
                    
                    HStack {
                        if let location = homeViewModel.selectedDashDropLocation {
                            Text(location.title)
                                .font(.system(size: 16, weight: .semibold))
                        }
                        
                        Spacer()
                        
                        Text(homeViewModel.dropOffTime ?? "")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.gray)
                    }
                }
                .padding(.leading, 8)
            }
            .padding()
            
            Divider()
            
            //Package Type
            Text("PACKAGE TYPE")
                .font(.subheadline)
                .fontWeight(.semibold)
                .padding()
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView(.horizontal) {
                HStack(spacing: 12) {
                    ForEach(PackageType.allCases) { type in
                        VStack(alignment: .leading) {
                            Image(type.imageName)
                                .resizable()
                                .scaledToFit()
                                .padding(.top, 10)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(type.description)
                                    .font(.system(size: 12, weight: .semibold))
                                    //.padding(.bottom, 10)
                                
                                Text(homeViewModel.computeRidePrice(forType: type).toCurrency())
                                    .font(.system(size: 10, weight: .semibold))
                                    .padding(.bottom, 5)
                            }
                            .padding(8)
                        }
                        .frame(width: 112, height: 140)
                        .foregroundColor(type == selectedPackageType ? .white : Color.theme.primaryTextColor)
                        .background(type == selectedPackageType ? .blue : Color.theme.secondaryBackgroundColor)
                        .scaleEffect(type == selectedPackageType ? 1.2 : 1.0)
                        .cornerRadius(10)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                selectedPackageType = type
                                isPackageTypeSelected = true
                                print("DEBUG: Selected package type: \(type)")
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
            
            Divider()
                .padding(.vertical, 8)
            
                
            
            //Prepaid option view
            NavigationLink(
                destination: PrepaidLabelView(
                    selectedImage: $selectedQRCodeImage,
                    didConfirmSelection: { image in
                        self.selectedQRCodeImage = image
                        // You might want to set isPrepaidOptionSelected to true here if needed
                    },
                    isSelectionMade: $isPrepaidOptionSelected // This assumes you have a State variable tracking this in OrderRequestView
                ),
                label: {
                    HStack(spacing: 12) {
                        Text("Select Prepaid Option")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .padding(6)
                            //.foregroundColor(Color.black) // If you want black text, remove the comment
                            .cornerRadius(4)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .imageScale(.medium)
                            .padding()
                    }
                    .frame(height: 50)
                    .background(Color.theme.secondaryBackgroundColor)
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
            )
            
            //confirm order button
            Button {
                homeViewModel.selectedQRCodeImage = self.selectedQRCodeImage
                homeViewModel.requestOrder()
            } label: {
                Text("CONFIRM ORDER")
                    .fontWeight(.bold)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 50)
                    .background(isConfirmOrderEnabled() ? Color.red : Color.gray)
                    .cornerRadius(10)
                    .foregroundColor(.white)
            }
            .disabled(!isConfirmOrderEnabled())
        }
        .padding(.bottom, 24)
        .background(Color.theme.backgroundColor)
        .cornerRadius(16)
    }
    
    private func isConfirmOrderEnabled() -> Bool {
        return isPackageTypeSelected && isPrepaidOptionSelected
        //return selectedQRCodeImage != nil
    }
}

//struct OrderRequestView_Previews: PreviewProvider {
//    static var previews: some View {
//        OrderRequestView()
//            .environmentObject(LocationSearchViewModel())
//    }
//}
