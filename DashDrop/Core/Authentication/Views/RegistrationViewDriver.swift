//
//  RegistrationViewDriver.swift
//  DashDrop
//
//  Created by Agam Bhullar on 3/9/24.
//

//
//  RegistrationView.swift
//  DashDrop
//
//  Created by Agam Bhullar on 3/2/24.
//

import SwiftUI

struct RegistrationViewDriver: View {
    @State private var fullname = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var alertMessage = ""
    @State private var showingSuccessAlert = false
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
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
                    
                    Text("Register as a driver")
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
                            viewModel.registerDriver(withEmail: email, 
                                                     password: password,
                                                     fullname: fullname) { success in
                                if success {
                                    // This closure is called after successful registration and user fetch.
                                    DispatchQueue.main.async {
                                        self.showingSuccessAlert = true
                                    }
                                } else {
                                    // Handle registration failure
                                    print("DEBUG: Failed to register as a driver.")
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
                        .background(Color("CustomColor1"))
                        .disabled(!formIsValid)
                        .opacity(formIsValid ? 1.0 : 0.5)
                        .cornerRadius(10)
                        .padding(.top, 24)
                        .alert(isPresented: $showingSuccessAlert) {
                            Alert(
                                title: Text("Success"),
                                message: Text("Your driver account has been created successfully."),
                                dismissButton: .default(Text("OK")) {
                                    // Action to perform when OK is tapped.
                                    dismiss()
                                }
                            )
                        }
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
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    private func attemptRegistration() {
        if email.isEmpty || !email.contains("@") {
            alertMessage = "Please enter a valid email address."
            showingSuccessAlert = true
        } else if password.isEmpty || password.count <= 5 {
            alertMessage = "Password must be at least 5 characters long."
            showingSuccessAlert = true
        } else if password != confirmPassword {
            alertMessage = "Passwords must match."
            showingSuccessAlert = true
        } else if fullname.isEmpty {
            alertMessage = "Please fill in all fields."
            showingSuccessAlert = true
        } else {
            viewModel.registerDriver(withEmail: email, password: password, fullname: fullname) { success in
                DispatchQueue.main.async {
                    if success {
                        // Handle successful registration
                        self.showingSuccessAlert = true
                    } else {
                        // Handle registration failure, update alert message and show alert
                        self.alertMessage = "An error occurred during registration."
                        self.showingSuccessAlert = true
                    }
                }
            }
        }
    }
}

extension RegistrationViewDriver: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
        && confirmPassword == password
        && !fullname.isEmpty
    }
}

struct RegistrationViewDriver_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationViewDriver()
    }
}
