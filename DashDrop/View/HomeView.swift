//
//  HomeView.swift
//  DashDrop
//
//  Created by Agam Bhullar on 2/19/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var userModel: UserModel
    @EnvironmentObject var navigationController: NavigationController
    @State private var isButtonPressed = false
    
    var body: some View {
        NavigationView {
            VStack {
                // Your HomeView content here
                NavigationLink(destination: ContentView(), isActive: $navigationController.shouldShowHomeView) {
                    Text("Request Pickup")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(isButtonPressed ? Color("CustomColor1").opacity(0.8) : Color("CustomColor1"))
                        .cornerRadius(10)
                        .shadow(radius: 10)
                }
                //Animation for Button Press
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in isButtonPressed = true }
                        .onEnded { _ in isButtonPressed = false }
                )
                .animation(.easeInOut(duration: 0.2), value: isButtonPressed)
                .padding()
            }
            .navigationBarTitle("Home", displayMode: .inline)
            .navigationBarItems(
                trailing: NavigationLink(destination: SettingsView().environmentObject(userModel)) {
                    Image(systemName: "person")
                        .foregroundColor(Color("CustomColor1"))
                    
                }
            )
        }
    }
}
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        // Create an instance of NavigationController
        let navigationController = NavigationController()
        
        // Provide both the UserModel and NavigationController as environment objects
        HomeView()
            .environmentObject(UserModel())
            .environmentObject(navigationController)
    }
}
