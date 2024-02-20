//
//  HomeView.swift
//  DashDrop
//
//  Created by Agam Bhullar on 2/19/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack {
                // Your HomeView content here
                NavigationLink(destination: ContentView()) {
                    Text("Request Pickup")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
            }
            .navigationBarTitle("Home", displayMode: .inline)
        }
    }
}
