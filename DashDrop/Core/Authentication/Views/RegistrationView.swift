//
//  RegistrationView.swift
//  DashDrop
//
//  Created by Harpreet Basota on 3/1/24.
//

import SwiftUI

struct RegistrationView: View {
    @State private var fullname = ""
    @State private var email = ""
    @State private var password = ""
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        ZStack{
            VStack(alignment: .leading, spacing: 20){
                Button{
                    dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.title)
                        .imageScale(.medium)
                        .padding()
                }
                
                Text("Create new account")
                    .font(.system(size: 40))
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.leading)
                    .frame(width: 250)
                
                Spacer()
                
                VStack{
                    VStack(spacing: 56){
                        CustomInputField(text: $fullname, title: "Full Name", placeholder: "Enter your name")
                        
                        CustomInputField(text: $email, title: "Email", placeholder: "Enter your email")
                        
                        CustomInputField(text: $password, title: " Create Password", placeholder: "Enter your password", isSecuredField: true)
                    }
                    .padding(.leading)
                    
                    Spacer()
                    Button{
                        viewModel.registerUser(withEmail: email, password: password, fullname: fullname)
                    } label: {
                        HStack{
                            Text("SIGN UP")
                                .foregroundColor(.white)
                            Image(systemName: "arrow.right")
                                .foregroundColor(.white)
                            
                        }
                        .frame(width: UIScreen.main.bounds.width - 32, height: 50)
                    }
                    
                    .background(Color.red)
                    .cornerRadius(10)
                    
                    Spacer()
                }
                
            }
        }
    }
}

struct RegiostrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
