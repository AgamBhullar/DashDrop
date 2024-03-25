//
//  RegistrationView.swift
//  DashDrop
//
//  Created by Agam Bhullar on 3/2/24.
//

import SwiftUI

struct RegistrationView: View {
    @State private var fullname = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showingSuccessAlert = false
    @State private var alertMessage = ""
    @State private var isLoading = false
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var homeViewModel: HomeViewModel
    @State private var animate = false
    
    var body: some View {
        ZStack {
            Color(.black)
                .ignoresSafeArea()
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.title)
                            .foregroundColor(Color("CustomColor1"))
                            .imageScale(.medium)
                            .padding()
                        
                    }
                    
                    Text("Create new account")
                        .font(.system(size: 40))
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.leading)
                        .frame(width: 250)
                    
                    
                    Spacer()
                    
                    VStack {
                        VStack(spacing: 40) {
                            CustomInputField(text: $fullname, title: "Full Name", placeholder: "Enter your name")
                            
                            CustomInputField(text: $email, title: "Email Address", placeholder: "name@example.com")
                                .autocapitalization(.none)
                            
                            CustomInputField(text: $password, title: "Create Password", placeholder: "Enter your password", isSecureField: true)
                            
                            ZStack(alignment: .trailing) {
                                CustomInputField(text: $confirmPassword, title: "Confirm Password", placeholder: "Confirm your password", isSecureField: true)
                                if !password.isEmpty && !confirmPassword.isEmpty {
                                    if password == confirmPassword {
                                        Image(systemName: "checkmark.circle.fill")
                                            .imageScale(.large)
                                            .fontWeight(.bold)
                                            .foregroundColor(Color(.systemGreen))
                                    } else {
                                        Image(systemName: "xmark.circle.fill")
                                            .imageScale(.large)
                                            .fontWeight(.bold)
                                            .foregroundColor(Color(.systemRed))
                                    }
                                }
                            }
                        }
                        .padding(.leading)
                        
                        Spacer()
                        
                        Button {
                            authViewModel.registerUser(withEmail: email,
                                                     password: password,
                                                     fullname: fullname) { success in
                                if success {
                                    // Sign-in succeeded
                                    homeViewModel.handleUserRoleChanged()
                                } else {
                                    // Sign-in failed, possibly handle this case or show an error message
                                    // The error message is already being set in the signIn method
                                    //showAlert = true // Show an alert if needed
                                }
                            }
                                
                        } label: {
                                HStack {
                                    Text("SIGN UP")
                                        .foregroundColor(.black)
                                    Image(systemName: "arrow.right")
                                        .foregroundColor(.black)
                                }
                                .frame(width: UIScreen.main.bounds.width - 32, height: 50)
                                .scaleEffect(animate ? 1.1 : 1.0)
                        }
                        .disabled(!formIsValid || isLoading)
                        .background(Color("CustomColor1"))
                        .opacity(formIsValid ? 1.0 : 0.5)
                        .cornerRadius(10)
                        .padding(.top, 24)
//                        .alert(isPresented: $showingSuccessAlert) {
//                            Alert(
//                                title: Text("Success"),
//                                message: Text("Your user account has been created successfully."),
//                                dismissButton: .default(Text("OK")) {
//                                    // Action to perform when OK is tapped.
//                                    dismiss()
//                                }
//                            )
//                        }
                        .onAppear {
                            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                                animate = true
                            }
                        }
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.clear.onTapGesture {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    })
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                self.hideKeyboard()
            }
            .foregroundColor(.white)
            .navigationBarBackButtonHidden(true)
        }
    }
    
//    private func signUpAction() {
//        isLoading = true // For testing, do not wait for completion
//        authViewModel.registerUser(withEmail: email, password: password, fullname: fullname) { success, errorMessage in
//            DispatchQueue.main.async {
//                if success {
//                    print("DEBUG: User registered successfully.")
//                    // Proceed with any actions following successful registration
//                } else {
//                    print("DEBUG: Registration failed: \(errorMessage ?? "Unknown error")")
//                    // Handle registration failure, perhaps by showing an alert to the user
//                }
//            }
//        }
//    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension RegistrationView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
        && confirmPassword == password
        && !fullname.isEmpty
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
