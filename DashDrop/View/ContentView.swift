//
//  ContentView.swift
//  DashDrop
//
//  Created by Agam Bhullar on 2/13/24.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel: ContentViewModel
    @StateObject var orderDetails = OrderDetails() 
    @StateObject var mapViewModel = MapViewModel()
    @State private var isRequestingPickup = false
    @FocusState private var isFocusedTextField: Bool
    
    var body: some View {
            NavigationView {
                VStack(alignment: .leading, spacing: 0) {
                    if isRequestingPickup {
                        TextField("Enter Pickup Address", text: $viewModel.searchableText)
                            .padding()
                            .autocorrectionDisabled()
                            .focused($isFocusedTextField)
                            .font(.title)
                            .onReceive(
                                viewModel.$searchableText.debounce(
                                    for: .seconds(1),
                                    scheduler: DispatchQueue.main
                                )
                            ) {
                                viewModel.searchAddress($0)
                            }
                            .background(Color.init(uiColor: .systemBackground))
                            .overlay {
                                ClearButton(text: $viewModel.searchableText)
                                    .padding(.trailing)
                                    .padding(.top, 8)
                            }
                            .onAppear {
                                isFocusedTextField = true
                            }
                        
                        List(self.viewModel.results) { address in
                            AddressRow(address: address, orderDetails: orderDetails, mapViewModel: mapViewModel)
                                .listRowBackground(backgroundColor)
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                    } else {
                        Button("Request Pickup") {
                            isRequestingPickup = true
                        }
                        .font(.title)
                        .padding()
                    }
                }
                .background(backgroundColor)
                .edgesIgnoringSafeArea(.bottom)
            }
        }
        
        var backgroundColor: Color = Color.init(uiColor: .systemGray6)
    }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ContentViewModel())
    }
}
