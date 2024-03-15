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
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var animate = false
    
    var body: some View {
        ZStack {
            Color(.black)
                .ignoresSafeArea()
            
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
                        
                        CustomInputField(text: $password, title: "Confirm Password", placeholder: "Confirm your password", isSecureField: true)
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
                    .padding(.leading)
                    
                    Spacer()
                    
                    Button {
                        viewModel.registerUser(withEmail: email, 
                                               password: password,
                                               fullname: fullname)
                            //self.showingSuccessAlert = true
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
                    .onAppear {
                        withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                            animate = true
                        }
                    }
                    
                    Spacer()
                }
            }
            .foregroundColor(.white)
            .navigationBarBackButtonHidden(true)
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Registration Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            
        }
    }
    
    private func attemptRegistration() {
        if email.isEmpty || !email.contains("@") {
            alertMessage = "Please enter a valid email address."
            showingAlert = true
        } else if password.isEmpty || password.count <= 5 {
            alertMessage = "Password must be at least 5 characters long."
            showingAlert = true
        } else if password != confirmPassword {
            alertMessage = "Passwords must match."
            showingAlert = true
        } else if fullname.isEmpty {
            alertMessage = "Please fill in all fields."
            showingAlert = true
        } else {
            viewModel.registerUser(withEmail: email, password: password, fullname: fullname)
        }
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
