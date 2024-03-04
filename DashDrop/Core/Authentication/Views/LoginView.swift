//
//  LoginView.swift
//  DashDrop
//
//  Created by Harpreet Basota on 3/1/24.
//

import SwiftUI

struct LoginView: View {
    @State var email = ""
    @State var passward = ""
    var body: some View {
       
        NavigationStack {
            ZStack{
                VStack{
                    // image and Title
                    
                    VStack{
                        Image("logo")
                            .resizable()
                            .frame(width: 200, height: 200)
                            
                    }
                    
                    // input fields
                    
                    VStack(spacing: 32){
                        // input field 1
                        
                        // reusing from the CustomInputField
                        CustomInputField(text: $email, title: "Email Address", placeholder: "name@example.com")
                        
                        // inputfiled 2

                        // reusing from the CustomInputField
                        CustomInputField(text: $passward, title: "password", placeholder: "Enter your Password", isSecuredField: true)
                        
                        Button{
                            
                        } label: {
                            Text("Forgot Password?")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.black)
                                .padding(.top)
                                
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        
                    }
                    .padding(.horizontal)
                    .padding(.top, 12)
                    
                    
                    // social sign in view
                    VStack{
                        // dividers + text
                        HStack(spacing: 24){
                            Rectangle()
                                .frame(width: 76, height: 1)
                                .foregroundColor(.black)
                                .opacity(0.5)
                            
                            Text("Sign in with social")
                                .foregroundColor(.red)
                                .fontWeight(.semibold)
                            
                            Rectangle()
                                .frame(width: 76, height: 1)
                                .foregroundColor(.black)
                                .opacity(0.5)
                        
                            
                        }
                        HStack{
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
                    // sign in button
                    
                    Button{
                        
                    } label: {
                        HStack{
                            Text("SIGN IN")
                                .foregroundColor(.white)
                            Image(systemName: "arrow.right")
                                .foregroundColor(.white)
                            
                        }
                        .frame(width: UIScreen.main.bounds.width - 32, height: 50)
                    }
                    
                    .background(Color.red)
                    .cornerRadius(10)
                    
                    // sign up button
                    
                    Spacer()
                    
                    NavigationLink {
                        RegistrationView()
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        HStack{
                            Text("Don't have an account?")
                                .font(.system(size: 14))
                            
                            Text("Sign Up")
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .foregroundColor(.blue)
                    }
                }
            }
        }
    }
}

#Preview {
    LoginView()
}
