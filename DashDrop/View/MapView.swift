//
//  MapView.swift
//  DashDrop
//
//  Created by Agam Bhullar on 2/13/24.
//

//import SwiftUI
//import MapKit
//
//struct MapView: View {
//    
//    @StateObject private var viewModel = MapViewModel()
//    @State private var navigateToStoreSelection = false
//
//    private let address: AddressResult
//    
//    init(address: AddressResult) {
//        self.address = address
//    }
//    
//    var body: some View {
//        Map(
//            coordinateRegion: $viewModel.region,
//            annotationItems: viewModel.annotationItems,
//            annotationContent: { item in
//                MapMarker(coordinate: item.coordinate)
//            })
//        .onAppear {
//            self.viewModel.getPlace(from: address)
//        }
//        .edgesIgnoringSafeArea(.bottom)
//    }
//}


import SwiftUI
import MapKit

struct MapView: View {
    
    @StateObject private var viewModel = MapViewModel()
    @State private var navigateToStoreSelection = false // Used to activate NavigationLink programmatically
    
    private let address: AddressResult
    
    init(address: AddressResult) {
        self.address = address
    }
    
    var body: some View {
        //NavigationView { // Ensure NavigationView wraps your content
            ZStack {
                Map(coordinateRegion: $viewModel.region, annotationItems: viewModel.annotationItems, annotationContent: { item in
                    MapMarker(coordinate: item.coordinate)
                })
                VStack {
                    Spacer()
                    NavigationLink(destination: StoreSelectionView(), isActive: $navigateToStoreSelection) { EmptyView() }
                    Button("Select Store") {
                        navigateToStoreSelection = true // This triggers the navigation
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .shadow(radius: 3)
                }
            }
            .onAppear {
                self.viewModel.getPlace(from: address)
            }
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarTitle("Map", displayMode: .inline) // Optionally set a navigation bar title
        //}
    }
}
