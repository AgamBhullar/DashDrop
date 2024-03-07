import SwiftUI
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOption launchOptions: [UIApplication : Any]? = nil) async -> Bool {
        FirebaseApp.configure()
        
        
    return true
    }
}


@main
struct DoorDashSwiftApp: App {
    @StateObject var locationViewModel = LocationSearchViewModel()
    @StateObject var authViewModel = AuthViewModel()
    @StateObject var homeViewModel = HomeViewModel()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(locationViewModel)
                .environmentObject(authViewModel)
                .environmentObject(homeViewModel)
        }
    }
}
