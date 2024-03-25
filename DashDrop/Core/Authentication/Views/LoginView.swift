//
//  LoginView.swift
//  DashDrop
//
//  Created by Agam Bhullar on 3/2/24.
//

import SwiftUI

struct LoginView: View {
    @State var email = ""
    @State var password = ""
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var homeViewModel: HomeViewModel
    @State private var animate = false
    @State private var showAlert = false
    @State private var navigateToPasswordReset = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.black)
                    .ignoresSafeArea()
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        // image and title
                        
                        VStack {
                            Image("Logo")
                                .resizable()
                                .frame(width: 300, height: 250)
                        }
                        
                        // input fields
                        
                        VStack(spacing: 22) {
                            //input field 1
                            CustomInputField(text: $email, title: "Email Address", placeholder: "name@example.com")
                                .autocapitalization(.none)
                            //input field 2
                            
                            CustomInputField(text: $password, title: "Password", placeholder: "Enter your password",
                                             isSecureField: true)
                            
                            Button {
                                navigateToPasswordReset = true
                            } label: {
                                Text("Forgot Password?")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding(.top)
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                        
                        //social sign in view
                        VStack {
                            //divider + text
                            HStack(spacing: 24) {
                                Rectangle()
                                    .frame(width: 76, height: 1)
                                    .foregroundColor(.white)
                                    .opacity(0.5)
                                
                                Text("Sign in with social")
                                    .foregroundColor(.white)
                                    .fontWeight(.semibold)
                                
                                Rectangle()
                                    .frame(width: 76, height: 1)
                                    .foregroundColor(.white)
                                    .opacity(0.5)
                            }
                            
                            //sign up buttons
                            HStack {
                                Button {
                                    
                                } label: {
                                    Image("google-sign-in-icon")
                                        .resizable()
                                        .frame(width: 44, height: 44)
                                }
                            }
                        }
                        .padding(.vertical)
                        
                        Spacer()
                        
                        //sign in button
                        Button {
                            showAlert = false // Reset alert visibility
                            authViewModel.signInErrorMessage = nil // Reset error message
                            authViewModel.signIn(withEmail: email, password: password) { success in
                                if success {
                                    // Sign-in succeeded
                                    homeViewModel.handleUserRoleChanged()
                                } else {
                                    // Sign-in failed, possibly handle this case or show an error message
                                    // The error message is already being set in the signIn method
                                    showAlert = true // Show an alert if needed
                                }
                            }
                        } label: {
                            HStack {
                                Text("SIGN IN")
                                    .foregroundColor(.black)
                                
                                Image(systemName: "arrow.right")
                                    .foregroundColor(.black)
                            }
                            .frame(width: UIScreen.main.bounds.width - 32, height: 50)
                            .scaleEffect(animate ? 1.1 : 1.0)
                        }
                        .background(Color("CustomColor1"))
                        .disabled(!formIsValid)
                        .opacity(formIsValid ? 1.0 : 0.5)
                        .cornerRadius(10)
                        .padding(.top, 24)
                        .onAppear {
                            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                                animate = true
                            }
                        }
                        
                        
                        //sign up button
                        
                        Spacer()
                        
                        NavigationLink {
                            RegistrationView()
                                .navigationBarBackButtonHidden(true)
                        } label: {
                            HStack {
                                Text("Don't have an account?")
                                    .font(.system(size: 14))
                                
                                Text("Sign Up")
                                    .font(.system(size: 14, weight: .semibold))
                            }
                            .foregroundColor(.white)
                        }
                        
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.clear.onTapGesture {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        })
                        
                        NavigationLink(destination: PasswordResetView(), isActive: $navigateToPasswordReset) {
                            EmptyView()
                        }
                    }
                }
            
                
                .contentShape(Rectangle())
                .onTapGesture {
                    self.hideKeyboard()
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("The email and password you entered don't match our records. "), message: Text(authViewModel.signInErrorMessage ?? "Unknown error"), dismissButton: .default(Text("OK")))
        }
//        .onChange(of: viewModel.signInErrorMessage) { _ in
//            showAlert.toggle() // This ensures a state change and triggers the alert
//        }
        .onChange(of: authViewModel.signInErrorMessage) { newValue in
            showAlert = newValue != nil
        }
    }
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension LoginView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
