//
//  AccountHelper.swift
//  RentalProperty
//
//  Created by joeyin on 2025/3/11.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AccountController: ObservableObject {
    private static var shared : AccountController?
    private var db = Firestore.firestore()
    
    @Published var user: User? {
        didSet { objectWillChange.send() }
    }
    
    init() {}
    
    static func getInstance() -> AccountController{
        if (shared == nil) {
            shared = AccountController()
        }
        
        return shared!
    }
    
    func fetchUserByUID(uid: String, completion: @escaping (Result<UserProfile?, Error>) -> Void) {
        db.collection("profile").document(uid).getDocument { document, error in
            if let error = error {
                print(#function, "Failed to fetch profile: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let document = document, document.exists else {
                print(#function, "No profile found for user \(uid)")
                completion(.success(nil))
                return
            }
            
            do {
                let result = try document.data(as: UserProfile.self)
                completion(.success(result))
            } catch {
                print(#function, "Failed to decode profile: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    func signUp(name: String, phone: String, email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Signup Failed: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let user = result?.user else {
                completion(.failure(NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "User creation failed"])))
                return
            }
            
            let profileData: [String: Any] = [
                "displayName": name,
                "phoneNumber": phone,
                "photoURL": "https://i.pravatar.cc/150?u=\(email)"
            ]
            
            self.db.collection("profile").document(user.uid).setData(profileData) { error in
                if let error = error {
                    print("Signup Failed: \(error.localizedDescription)")
                    completion(.failure(error))
                } else {
                    print("Signup Successful")
                    completion(.success(()))
                }
            }
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print(#function, "SignIn Failed: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let user = result?.user else {
                completion(.failure(NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not found"])))
                return
            }
                        
            self.fetchUserByUID(uid: user.uid) { result in
                switch result {
                    case .success(let profile):
                        self.user = Auth.auth().currentUser
                        self.user?.displayName = profile?.displayName
                        self.user?.phoneNumber = profile?.phoneNumber
                        if let url = profile?.photoURL {
                            self.user?.photoURL = URL(string: url)
                        }
                        completion(.success(()))
                    
                    case .failure(let error):
                        completion(.failure(error))
                }
                
            }
        }
    }
    
    func updateUserProfile(displayName: String, phoneNumber: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(.failure(NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])))
            return
        }
        
        let updatedData: [String: Any] = [
            "displayName": displayName,
            "phoneNumber": phoneNumber
        ]
        
        db.collection("profile").document(user.uid).setData(updatedData, merge: true) { error in
            if let error = error {
                print("Failed to update profile: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            self.fetchUserByUID(uid: user.uid) { result in
                switch result {
                    case .success(let profile):
                        self.user = Auth.auth().currentUser
                        self.user?.displayName = profile?.displayName
                        self.user?.phoneNumber = profile?.phoneNumber
                        if let url = profile?.photoURL {
                            self.user?.photoURL = URL(string: url)
                        }
                        completion(.success(()))
                    
                    case .failure(let error):
                        completion(.failure(error))
                }
            }
        }
    }
    
    func rememberMe(enable: Bool = false, email: String, password: String) {
        if (enable) {
            let user = LoginForm(email: email, password: password, remember: enable)
            if let encodedData = try? JSONEncoder().encode(user) {
                UserDefaultsHelper.set(.LOGIN_FORM, encodedData)
            }
        } else {
            UserDefaultsHelper.remove(.LOGIN_FORM)
        }
    }
    
    func getRememberedLoginData() -> LoginForm? {
        guard let value: Data = UserDefaultsHelper.get(.LOGIN_FORM) else {
            return nil
        }

        return try? JSONDecoder().decode(LoginForm.self, from: value)
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.user = nil
        } catch let err as NSError{
            print("Unable to sign out \(err)")
        }
    }

    func isLoggedIn() -> Bool {
        return user != nil
    }
    
}
