//
//  AuthViewModel.swift
//  DashDrop
//
//  Created by Arjun Takhar on 3/1/24.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import Combine

class AuthViewModel: ObservableObject{
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    private let service = UserService.shared
    private var cancellables = Set<AnyCacellable>()
    
    init() {
        userSession = Auth.auth().currentUser
        fetchUser()
    }
    
    func signIn(withEmail email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("DEBUG: Failed to sign in with error \(error.localizedDescription)")
                return
            }
            self.userSession = result?.user
            self.fetchUser()
        }
    }
    
    func registerUser(withEmail email: String, password: String, fullname: String) {
        gaurd let location = LocationManager.shared.userLocation else { return }
        
        
        Auth.auth().createUser(withEmail: email, password: password) {
            result, error in
            if let error = error {
                print("DEBUG: Failed to sign up with error \(error.localizedDescription)")
                retun
            }
            
            gaurd let firebaseUser = result?.user else { return }
            self.userSession = firebaseUser
            
            let user = User(
                fullname: fullname,
                email: email,
                uid: firebaseUser.uid,
                coordinates: GeoPoint(latitude: location.latitude, longitude: location.longitude),
                accountType: .driver
            )
            
            self.currentUser = user
            gaurd let encodedUser = try? Firestore.Encoder().encode(user) else { return }
            Firestore.firestore().collection("users").document(firebaseUser.uid).setData(encodedUser)
        }
    }
    
    func signout() {
        do {
            try Auth.auth().signout()
            self.userSession = nil
        } catch let error {
            print("DEBUG: Failed to sign out with error: \(error.localizedDescription)")
        }
    }
    
    func fetchUser() {
        service.$user
            .sink { user in
                self.currentUser = user
            }
            .store(in: &cancellables)
}
