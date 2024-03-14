////
////  AuthViewModel.swift
////  DashDrop
////
////  Created by Agam Bhullar on 3/2/24.
////
//
//import Foundation
//import Firebase
//import FirebaseFirestoreSwift
//import Combine
//
//class AuthViewModel: ObservableObject {
//    @Published var userSession: FirebaseAuth.User?
//    @Published var currentUser: User?
//    
//    private let service = UserService.shared
//    private var cancellables = Set<AnyCancellable>()
//    
//    init() {
//        userSession = Auth.auth().currentUser
//        
//        Task {
//            fetchUser()
//        }
//    }
//    
////    func signIn(withEmail email: String, password: String) {
////        Auth.auth().signIn(withEmail: email, password: password) { result, error in
////            if let error = error {
////                print("DEBUG: Failed to sign in with error \(error.localizedDescription)")
////                return
////            }
////
////            self.userSession = result?.user
////            self.fetchUser()
////        }
////    }
//    
//    func signIn(withEmail email: String, password: String) async {
//        do {
//            let result = try await Auth.auth().signIn(withEmail: email, password: password)
//            DispatchQueue.main.async {
//                self.userSession = result.user
//                self.fetchUser()
//            }
//        } catch let error {
//            print("DEBUG: Login error: \(error.localizedDescription)")
//        }
//    }
//    
////    func registerUser(withEmail email: String, password: String, fullname: String) {
////        guard let location = LocationManager.shared.userLocation else { return }
////        
////        Auth.auth().createUser(withEmail: email, password: password) { result, error in
////            if let error = error {
////                print("DEBUG: Failed to sign up with error \(error.localizedDescription)")
////                return
////            }
////
////            guard let firebaseUser = result?.user else { return }
////            self.userSession = firebaseUser
////
////            let user = User(
////                fullname: fullname,
////                email: email,
////                uid: firebaseUser.uid,
////                coordinates: GeoPoint(latitude: location.latitude, longitude: location.longitude),
////                accountType: .driver
////            )
////
////            self.currentUser = user
////            guard let encodedUser = try? Firestore.Encoder().encode(user) else { return }
////            Firestore.firestore().collection("users").document(firebaseUser.uid).setData(encodedUser)
////        }
////    }
//    
//    func registerUser(withEmail email: String, password: String, fullname: String, accountType: AccountType = .customer, completion: @escaping () -> Void) {
//        guard let location = LocationManager.shared.userLocation else { return }
//      
//        Auth.auth().createUser(withEmail: email, password: password) { result, error in
//            if let error = error {
//                print("DEBUG: Failed to sign up with error \(error.localizedDescription)")
//                return
//            }
//            
//            guard let firebaseUser = result?.user else { return }
//            self.userSession = firebaseUser
//            
//            let user = User(
//                fullname: fullname,
//                email: email,
//                uid: firebaseUser.uid,
//                coordinates: GeoPoint(latitude: location.latitude, longitude: location.longitude),
//                accountType: accountType // Use the accountType parameter
//            )
//            
//            guard let encodedUser = try? Firestore.Encoder().encode(user) else { return }
//            Firestore.firestore().collection("users").document(firebaseUser.uid).setData(encodedUser) {
//                error in
//                if let error = error {
//                    print("DEBUG: Error saving user info: \(error.localizedDescription)")
//                } else {
//                    self.currentUser = user
//                    completion()
//                    print("DEBUG: successfully logged out")
//                }
//            }
//        }
//    }
//
//    
//    func signout() {
//        do {
//            try Auth.auth().signOut()
//            DispatchQueue.main.async {
//                self.userSession = nil
//                self.currentUser = nil
//                UserService.shared.user = nil
//                // Ensure UI is reacting to these changes
//            }
//        } catch let signOutError as NSError {
//            print("DEBUG: Error signing out: %@", signOutError)
//        }
//    }
//    
//    func fetchUser() {
//        service.$user
//            .receive(on: RunLoop.main)
//            .sink { user in
//                self.currentUser = user
//            }
//            .store(in: &cancellables)
//    }
//    
//}


//
//  AuthViewModel.swift
//  UberSwiftUITutorial
//
//  Created by Stephan Dowless on 12/13/22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import Combine

class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    
    private let service = UserService.shared
    private var cancellables = Set<AnyCancellable>()
    
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
            
            print("DEBUG: Sign user in successfully")
            print("DEBUG: User id: \(result?.user.uid)")

            self.userSession = result?.user
            self.fetchUser()
        }
    }
    
    func registerUser(withEmail email: String, password: String, fullname: String) {
        guard let location = LocationManager.shared.userLocation else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("DEBUG: Failed to sign up with error \(error.localizedDescription)")
                return
            }

            guard let firebaseUser = result?.user else { return }
            self.userSession = firebaseUser

            let user = User(
                fullname: fullname,
                email: email,
                uid: firebaseUser.uid,
                coordinates: GeoPoint(latitude: location.latitude, longitude: location.longitude),
                accountType: .customer
            )

            self.currentUser = user
            guard let encodedUser = try? Firestore.Encoder().encode(user) else { return }
            Firestore.firestore().collection("users").document(firebaseUser.uid).setData(encodedUser)
        }
    }
    
    func registerDriver(withEmail email: String, password: String, fullname: String) {
        guard let location = LocationManager.shared.userLocation else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("DEBUG: Failed to sign up with error \(error.localizedDescription)")
                return
            }

            guard let firebaseUser = result?.user else { return }
            self.userSession = firebaseUser

            let user = User(
                fullname: fullname,
                email: email,
                uid: firebaseUser.uid,
                coordinates: GeoPoint(latitude: location.latitude, longitude: location.longitude),
                accountType: .driver
            )

            self.currentUser = user
            guard let encodedUser = try? Firestore.Encoder().encode(user) else { return }
            Firestore.firestore().collection("users").document(firebaseUser.uid).setData(encodedUser)
        }
    }
    
    func signout() {
        do {
            try Auth.auth().signOut()
            print("DEBUG: Did sign out with firebase")
            self.userSession = nil
        } catch let error {
            print("DEBUG: Failed to sign out with error: \(error.localizedDescription)")
        }
    }
    
//    func fetchUser() {
//        service.$user
//            .sink { user in
//                self.currentUser = user
//            }
//            .store(in: &cancellables)
//    }
    
    func fetchUser() {
        guard let uid = self.userSession?.uid else { return }
        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, _ in
            guard let snapshot = snapshot else { return }
            
            guard let user = try? snapshot.data(as: User.self) else { return }
            self.currentUser = user
        }
    }
}


