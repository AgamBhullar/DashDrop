//
//  PasswordResetView.swift
//  DashDrop
//
//  Created by Harpreet Basota on 3/15/24.
//

import SwiftUI
import Firebase

struct PasswordResetView: View {
    @State private var email: String = ""
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isLoading = false

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
                
                Text("Reset Password")
                    .font(.system(size: 40))
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.leading)
                    .frame(width: 250)
                
                
                Spacer()
                
                VStack {
                    VStack(spacing: 56) {
                        CustomInputField(text: $email, title: "Email Address", placeholder: "name@example.com")
                            .autocapitalization(.none)
                    }
                    .padding(.leading)
                    .padding(.bottom, 20)
                    
                    Button {
                        isLoading = true
                        viewModel.sendPasswordResetEmail(to: email) { result in
                            DispatchQueue.main.async {
                                isLoading = false
                                switch result {
                                case .success:
                                    alertMessage = "A link to reset your password has been sent to your email."
                                    showAlert = true
                                case .failure(let error):
                                    alertMessage = "Failed to send reset link: \(error.localizedDescription)"
                                    showAlert = true
                                }
                            }
                        }
                    } label: {
                        HStack {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("RESET PASSWORD")
                                    .foregroundColor(.black)
                                
                                Image(systemName: "arrow.right")
                                    .foregroundColor(.black)
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width - 32, height: 50)
                    }
                    .background(Color("CustomColor1"))
                    .cornerRadius(10)
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Password Reset"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                    }
                    
                    Spacer()
                }
                .navigationBarBackButtonHidden(true)
            }
            .foregroundColor(.white)
        }
    }
}


#Preview {
    PasswordResetView()
}

