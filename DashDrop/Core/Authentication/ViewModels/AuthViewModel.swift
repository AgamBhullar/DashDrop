//
//  AuthViewModel.swift
//  DashDrop
//
//  Created by Harpreet Basota on 3/2/24.
//

import Foundation
import Firebase

class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    
    init() {
        userSession = Auth.auth().currentUser
    }
    func registerUser(withEmail email: String, password: String, fullname: String){
        Auth.auth().createUser(withEmail: email, password: password){ result, error in
            if let error = error{
                print("DEBUG: Failed to sign up with error \(error.localizedDescription)")
                return
            }
             print("DEBUG: Registred user succcefully")
            print("DEBUG: User id \(result?.user.uid)")
        }
    }
}


