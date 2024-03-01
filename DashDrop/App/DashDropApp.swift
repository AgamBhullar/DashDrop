//
//  DashDropApp.swift
//  DashDrop
//
//  Created by Agam Bhullar on 2/13/24.
//

import SwiftUI
import PhoneNumberKit
import Combine

enum AppState {
    case home
    case orderConfirmation
    case loading
    // Add other states as needed
}

class AppData: ObservableObject {
    //@Published var lastOrderDetails: OrderDetails?
    @Published var lastOrderDetails: OrderDetails?

    //@Published var shouldNavigateToHome = false
    //@Published var showHomeView = false
    // @Published var showingOrderConfirmation = false
    // @Published var currentState: AppState = .home
}
    
    // Navigation controller to manage navigation state
    class NavigationController: ObservableObject {
        @Published var shouldShowHomeView = false
        
        
    }
    
    @main
    struct DashDropApp: App {
        
       // @StateObject var orderDetails = OrderDetails()
        init() {
            Api.shared.appId = "QSQEo5xSmENL"
        }
        
        @StateObject var appData = AppData()
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
                                .environmentObject(appData)
                                .environmentObject(navigationController)
                           // .environmentObject(orderDetails)
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

