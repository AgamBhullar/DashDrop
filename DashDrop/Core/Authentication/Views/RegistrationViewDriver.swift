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
    @State private var showingSuccessAlert = false
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    
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
                        .imageScale(.medium)
                        .padding()
                }
                
                Text("Register as a driver")
                    .font(.system(size: 40))
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.leading)
                    .frame(width: 250)
                    .navigationBarBackButtonHidden(true)
                
                Spacer()
                
                VStack {
                    VStack(spacing: 56) {
                        CustomInputField(text: $fullname, title: "Full Name", placeholder: "Enter your name")
                        
                        CustomInputField(text: $email, title: "Email Address", placeholder: "name@example.com")
                            .autocapitalization(.none)
                        
                        CustomInputField(text: $password, title: "Create Password", placeholder: "Enter your password", isSecureField: true)
                    }
                    .padding(.leading)
                    
                    Spacer()
                    
                    Button {
                        viewModel.registerDriver(withEmail: email,
                                               password: password, fullname: fullname)
                            // This closure is called after successful registration.
                            self.showingSuccessAlert = true
                        
                    } label: {
                        HStack {
                            Text("SIGN UP")
                                .foregroundColor(.black)
                            
                            Image(systemName: "arrow.right")
                                .foregroundColor(.black)
                        }
                        .frame(width: UIScreen.main.bounds.width - 32, height: 50)
                    }
                    .background(Color("CustomColor1"))
                    .cornerRadius(10)
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
                    
                    Spacer()
                }
            }
            .foregroundColor(.white)
        }
    }
}

struct RegistrationViewDriver_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationViewDriver()
    }
}

