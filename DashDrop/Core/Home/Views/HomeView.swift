//
//  HomeView.swift
//  DashDrop
//
//  Created by Agam Bhullar on 3/1/24.
//

import SwiftUI

struct HomeView: View {
    @State private var mapState = MapViewState.noInput
    @State private var showSideMenu = false
//    @EnvironmentObject var locationViewModel: LocationSearchViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    var body: some View {
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
                    .onAppear {
                        showSideMenu = false
                    }
                }
            }
        }
    }
}

extension HomeView {
    var mapView: some View {
        ZStack(alignment: .bottom) {
            ZStack(alignment: .top) {
                MapViewRepresentable(mapState: $mapState)
                    .ignoresSafeArea()
                
                if mapState == .searchingForLocation {
                    LocationSearchView()
                } else if mapState == .noInput {
                    LocationSearchActivationView()
                        .padding(.top, 88)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                mapState = .searchingForLocation
                            }
                        }
                }
                
                MapViewActionButton(mapState: $mapState, showSideMenu: $showSideMenu)
                    .padding(.leading)
                    .padding(.top, 4)
            }
            
            if let user = authViewModel.currentUser {
                if user.accountType == .customer {
                    if mapState == .locationSelected || mapState == .polylineAdded {
                        OrderRequestView()
                            .transition(.move(edge: .bottom))
                    } else if mapState == .orderRequested {
                        // show order loading view
                        OrderLoadingView()
                            .transition(.move(edge: .bottom))
                    } else if mapState == .orderAccepted {
                        // show order accepted view
                        OrderAcceptedView()
                            .transition(.move(edge: .bottom))
                    } else if mapState == .orderRejected {
                        // show order rejected view
                    } else if mapState == .orderDelivered {
                        OrderDeliveredView()
                    }
                } else {
                    if let order = homeViewModel.order {
                        if mapState == .orderRequested {
                            AcceptOrderView(order: order)
                                .transition(.move(edge: .bottom))
                        } else if mapState == .orderAccepted {
                            PickupPackageView(order: order)
                                .transition(.move(edge: .bottom))
                        } else if mapState == .orderDelivered {
                            DriverDeliveredView(order: order)
                        }
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .onReceive(LocationManager.shared.$userLocation) { location in
            if let location = location {
                homeViewModel.userLocation = location
            }
        }
        .onReceive(homeViewModel.$selectedDashDropLocation) { location in
            if location != nil {
                self.mapState = .locationSelected
            }
        }
        .onReceive(homeViewModel.$order) { order in
            guard let order = order else { return }
            
            withAnimation(.spring()) {
                switch order.state {
                case .requested:
                    self.mapState = .orderRequested
                case .rejected:
                    self.mapState = .orderRejected
                case .accepted:
                    self.mapState = .orderAccepted
                case .delivered:
                    self.mapState = .orderDelivered
                }
            }
        }
    }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//            .environmentObject(AuthViewModel())
//    }
//}