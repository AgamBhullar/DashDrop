//
//  DashDropApp.swift
//  DashDrop
//
//  Created by Agam Bhullar on 2/13/24.
//

import SwiftUI
import PhoneNumberKit

// Navigation controller to manage navigation state
class NavigationController: ObservableObject {
    @Published var shouldShowHomeView = false
}

@main
struct DashDropApp: App {
    init() {
        Api.shared.appId = "QSQEo5xSmENL"
    }

    @StateObject var launchScreenManager = LaunchScreenManager()
    @StateObject var userModel = UserModel()
    // Initialize the navigation controller
    @StateObject private var navigationController = NavigationController()
    
    var body: some Scene {
        WindowGroup {
            Group {
                if let _ = userModel.authToken {
                    if userModel.currentUser != nil {
                        // Provide the navigation controller to the HomeView
                        HomeView()
                            .environmentObject(userModel)
                            .environmentObject(navigationController)
                    } else {
                        LoadingView()
                            .environmentObject(userModel)
                            .environmentObject(navigationController) //added line
                        
                    }
                } else {
                    ZStack {
                        LoginView()
                            .environmentObject(userModel)
                        if launchScreenManager.state != .completed {
                            LaunchScreenView()
                        }
                    }
                    .environmentObject(launchScreenManager)
                }
            }
        }
    }
}
