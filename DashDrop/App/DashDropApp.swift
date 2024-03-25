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
      //application.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)
    return true
  }
//    func application(_ application: UIApplication,
//                     performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        let homeViewModel = HomeViewModel.shared
//        
//        // Decide which function to call based on the user type
//        if let currentUser = homeViewModel.currentUser {
//            if currentUser.accountType == .driver {
//                // Driver: Fetch new orders
//                homeViewModel.fetchOrders {
//                    completionHandler(.newData)
//                }
//            } else if currentUser.accountType == .customer {
//                // Customer: Fetch new receipts
//                if let orderId = homeViewModel.order?.id {
//                    homeViewModel.fetchReceipt(forOrder: orderId) {
//                        completionHandler(.newData)
//                    }
//                } else {
//                    // No order ID to fetch for, thus no data
//                    completionHandler(.noData)
//                }
//            } else {
//                // Unrecognized user type or not logged in, no data to fetch
//                completionHandler(.noData)
//            }
//        } else {
//            // User not logged in, no data to fetch
//            completionHandler(.noData)
//        }
//    }
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
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                // Initiate the transition with animation
                                withAnimation(.easeOut(duration: 0.25)) {
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
