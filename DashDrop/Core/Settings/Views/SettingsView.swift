//
//  SettingsView.swift
//  DashDrop
//
//  Created by Agam Bhullar on 3/4/24.
//

import SwiftUI

struct SettingsView: View {
    private let user: User
    @EnvironmentObject var viewModel: AuthViewModel
    
    init(user: User) {
        self.user = user
    }
    
    var body: some View {
        if let user = viewModel.currentUser {
            VStack {
                List {
                    Section {
                        //user info header
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
                            
                            Spacer()
                            Image(systemName: "chevron.right")
                                .imageScale(.small)
                                .font(.title2)
                                .foregroundColor(.gray)
                        }
                        .padding(8)
                    }
                    
                    Section("Favorites") {
                        ForEach(SavedLocationViewModel.allCases) { viewModel in
                            NavigationLink {
                                SavedLocationSearchView(config: viewModel)
                            } label: {
                                SavedLocationRowView(viewModel: viewModel, user: user)
                            }
                        }
                    }
                    
                    Section("Settings") {
                        SettingsRowView(imageName: "bell.circle.fill",
                                        title: "Notifications",
                                        tintColor: Color(.systemOrange))
                        
                        SettingsRowView(imageName: "creditcard.circle.fill",
                                        title: "Payment Methods",
                                        tintColor: Color(.systemBlue))
                    }
                    
                    Section("Account") {
                        SettingsRowView(imageName: "dollarsign.square.fill",
                                        title: "Become a driver",
                                        tintColor: Color(.systemGreen))
                        
                        SettingsRowView(imageName: "arrow.left.square.fill",
                                        title: "Sign out",
                                        tintColor: Color(.systemRed))
                        .onTapGesture {
                            viewModel.signout()
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingsView(user: dev.mockUser)
        }
    }
}
