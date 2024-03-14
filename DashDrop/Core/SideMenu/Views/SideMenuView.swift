//
//  SideMenuView.swift
//  DashDrop
//
//  Created by Agam Bhullar on 3/3/24.
//

import SwiftUI

struct SideMenuView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    private let user: User
    
    init(user: User) {
        self.user = user
    }
    
    var body: some View {
        if let user = viewModel.currentUser {
            VStack(spacing: 40) {
                // header view
                VStack(alignment: .leading, spacing: 32) {
                    //user info
                    HStack {
                        Text(user.initials)
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 72, height: 72)
                            .background(Color(.systemGray3))
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text(user.fullname)
                                .font(.system(size: 16, weight: .semibold))
                            
                            Text(user.email)
                                .font(.system(size: 14))
                                .accentColor(Color.theme.primaryTextColor)
                                .opacity(0.77)
                        }
                    }
                    
                    //become a driver
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Do more with your account")
                            .font(.footnote)
                            .fontWeight(.semibold)
                        
                        NavigationLink(destination: RegistrationViewDriver()) {
                            HStack {
                                Image(systemName: "dollarsign.square")
                                    .font(.title2)
                                    .imageScale(.medium)
                                
                                Text("Become A Driver ")
                                    .font(.system(size: 16, weight: .semibold))
                                    .padding(6)
                            }
                        }
                    }
                    
                   Rectangle()
                        .frame(width: 296, height: 0.75)
                        .opacity(0.7)
                        .foregroundColor(Color(.separator))
                        .shadow(color: .black.opacity(0.7), radius: 4)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 16)
                            
                //option list
                VStack {
                    ForEach(SideMenuOptionViewModel.allCases) { viewModel in
                        NavigationLink(value: viewModel) {
                            SideMenuOptionView(viewModel: viewModel)
                                .padding()
                        }
                    }
                }
                .navigationDestination(for: SideMenuOptionViewModel.self) { viewModel in
                    switch viewModel {
                    case .orders:
                        //Text("Orders")
                        OrdersView(viewModel: OrdersViewModel())
                    case .wallet:
                        Text("Wallet")
                    case .settings:
                        SettingsView(user: user)
                    case .messages:
                        Text("Messages")
                    }
                }
                
                Spacer()
            }
            .padding(.top, 32)
        }
    }
}

struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            SideMenuView(user: dev.mockUser)
        }
    }
}
