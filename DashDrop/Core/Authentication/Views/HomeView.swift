import SwiftUI

struct HomeView: View {
    @State private var mapState = MapViewState.noInput
    @State private var showSideMenu = false
    @EnvironmentObject var locationViewModel : LocationSearchViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    var body: some view {
        Group {
            if authViewModel.userSession == nil {
                LoginView()
            } else if let user = authViewModel.currentUser {
                NavigationStack {
                    ZStack {
                        if showSideMenu {
                            SideMenuView(user: user)
                        }
                        
                        mapView
                            .offset(x: showSideMenu ? 316 : 0)
                            .shadow(color: showSideMenu ? .black : .clear,
                                    radius: 10)
                    }
                    .onAppear{
                        showSideMenu = false
                    }
                }
            }
        }
    }
    
}
