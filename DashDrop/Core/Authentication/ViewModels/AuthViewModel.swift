import Foundation
import Firebase
import FirebaseFirestoreSwift
import Combine

protocol AuthenticationFormProtocol {
    var formIsValid: Bool { get }
}

extension Notification.Name {
    static let userAuthenticationChanged = Notification.Name("userAuthenticationChanged")
}

class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var signInErrorMessage: String?
    
    private let service = UserService.shared
    private var cancellables = Set<AnyCancellable>()
    
//    init() {
//        userSession = Auth.auth().currentUser
//        fetchUser()
//    }
    
    init() {
        Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            self?.userSession = user
            if let user = user {
                // User is signed in, now fetch user details
                print("DEBUG: User is signed in with UID: \(user.uid)")
                self?.fetchUser()
            } else {
                // No user is signed in
                print("DEBUG: No user is currently signed in.")
                self?.userSession = nil
                self?.currentUser = nil
            }
        }
    }
    
    func signIn(withEmail email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.signInErrorMessage = error.localizedDescription
                }
                return
            }
            
            // Success handling
            DispatchQueue.main.async {
                self.signInErrorMessage = nil
                self.userSession = result?.user
                self.fetchUser()
            }
        }
    }
    
//    func registerUser(withEmail email: String, password: String, fullname: String, completion: @escaping (Bool) -> Void) {
//        guard let location = LocationManager.shared.userLocation else { return completion(false)}
//        
//        Auth.auth().createUser(withEmail: email, password: password) { result, error in
//            if let error = error {
//                print("DEBUG: Failed to sign up with error \(error.localizedDescription)")
//                return completion(false)
//            }
//
//            guard let firebaseUser = result?.user else { return completion(false)  }
//            self.userSession = firebaseUser
//
//            let user = User(
//                fullname: fullname,
//                email: email,
//                uid: firebaseUser.uid,
//                coordinates: GeoPoint(latitude: location.latitude, longitude: location.longitude),
//                accountType: .customer
//            )
//
//            self.currentUser = user
//            guard let encodedUser = try? Firestore.Encoder().encode(user) else { return }
//            Firestore.firestore().collection("users").document(firebaseUser.uid).setData(encodedUser) { err in
//                if let err = err {
//                    print("Error adding document: \(err)")
//                    completion(false)
//                } else {
//                    self.fetchUser() 
//                    completion(true)
//                }
//            }
//        }
//    }
    
    func registerUser(withEmail email: String, password: String, fullname: String, completion: @escaping (Bool) -> Void) {
        print("DEBUG: Starting registration process")
        guard let location = LocationManager.shared.userLocation else { return completion(false) }

        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("DEBUG: Failed to sign up with error \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(false)
                }
                return
            }

            guard let firebaseUser = result?.user else {
                DispatchQueue.main.async {
                    completion(false)
                }
                return
            }
            self.userSession = firebaseUser
            print("DEBUG: Firebase user created successfully, UID: \(firebaseUser.uid)")
            let user = User(fullname: fullname, email: email, uid: firebaseUser.uid, coordinates: GeoPoint(latitude: location.latitude, longitude: location.longitude), accountType: .customer)

            self.currentUser = user
            guard let encodedUser = try? Firestore.Encoder().encode(user) else {
                DispatchQueue.main.async {
                    completion(false)
                }
                return
            }

            Firestore.firestore().collection("users").document(firebaseUser.uid).setData(encodedUser) { err in
                DispatchQueue.main.async {
                    if let err = err {
                        print("Error adding document: \(err)")
                        completion(false)
                    } else {
                        print("User document added successfully")
                        self.fetchUser()
                        completion(true)
                    }
                }
            }
        }
    }


    
    func registerDriver(withEmail email: String, password: String, fullname: String, completion: @escaping (Bool) -> Void) {
        guard let location = LocationManager.shared.userLocation else { return completion(false) }
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("DEBUG: Failed to sign up with error \(error.localizedDescription)")
                return completion(false)
            }
            
            guard let firebaseUser = result?.user else { return completion(false) }
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
            Firestore.firestore().collection("users").document(firebaseUser.uid).setData(encodedUser) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                    completion(false)
                } else {
                    self.fetchUser() // Make sure fetchUser updates on the main thread if necessary
                    completion(true)
                }
            }
        }
    }
    
    func signout() {
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                print("DEBUG: Did sign out with firebase")
                self.userSession = nil
                self.currentUser = nil  // Ensure currentUser is also reset
                
                // Post notification
                NotificationCenter.default.post(name: .userAuthenticationChanged, object: nil)
            }
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
    
    func sendPasswordResetEmail(to email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
