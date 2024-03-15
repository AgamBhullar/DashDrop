//
//  DashDropApp.swift
//  DashDrop
//
//  Created by Agam Bhullar on 3/1/24.
//

//import SwiftUI
//import Firebase
//
//class AppDelegate: NSObject, UIApplicationDelegate {
//  func application(_ application: UIApplication,
//                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//    FirebaseApp.configure()
//
//    return true
//  }
//}
//
//
//@main
//struct DashDropApp: App {
////    @StateObject var locationViewModel = LocationSearchViewModel()
//    @StateObject var authViewModel = AuthViewModel()
//    @StateObject var homeViewModel = HomeViewModel()
//    @StateObject var launchScreenManager = LaunchScreenManager()
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
//    
//    var body: some Scene {
//        WindowGroup {
//            HomeView()
////                .environmentObject(locationViewModel)
//                .environmentObject(authViewModel)
//                .environmentObject(homeViewModel)
//        }
//    }
//}



import SwiftUI
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}


@main
struct DashDropApp: App {
    @StateObject var authViewModel = AuthViewModel()
    @StateObject var homeViewModel = HomeViewModel()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    // Add a state to control the display of the launch screen
    @State var isShowingLaunchScreen = true
    @StateObject var launchScreenManager = LaunchScreenManager()

    var body: some Scene {
        WindowGroup {
            Group {
                if isShowingLaunchScreen {
                    LaunchScreenView()
                        .environmentObject(launchScreenManager)
                        .onAppear {
                            // Simulate a delay for the launch screen
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                // Initiate the transition with animation
                                withAnimation(.easeOut(duration: 0.2)) {
                                    isShowingLaunchScreen = false
                                    launchScreenManager.dismiss()
                                }
                            }
                        }
                } else {
                    // Once ready, show the main view
                    HomeView()
                        .environmentObject(authViewModel)
                        .environmentObject(homeViewModel)
                }
            }
        }
    }
}
