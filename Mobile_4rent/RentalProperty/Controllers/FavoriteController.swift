//
//  AccountHelper.swift
//  RentalProperty
//
//  Created by joeyin on 2025/3/11.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class FavoriteController: ObservableObject {
    private static var shared : FavoriteController?
    private var db = Firestore.firestore()
        
    @Published var favoriteIDs: [String] = []
    
    init(db: Firestore) {
        self.db = db
    }
    
    static func getInstance() -> FavoriteController {
        if (shared == nil) {
            shared = FavoriteController(db: Firestore.firestore())
        }
        
        return shared!
    }
    
    func likeProperty(userID: String, propertyID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let favoriteRef = db.collection("favorite").document("\(userID)_\(propertyID)")
        
        let favoriteData: [String: Any] = [
            "userID": userID,
            "propertyID": propertyID,
            "timestamp": FieldValue.serverTimestamp()
        ]
        
        favoriteRef.setData(favoriteData) { error in
            if let error = error {
                print(#function, "Failed to like property: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                print(#function, "Property liked successfully")
                
                self.fetchFavoritesByUserID(userID: userID) { result in
                    switch result {
                        case .success(_):
                            completion(.success(()))
                        case .failure(let error):
                            completion(.failure(error))
                    }
                }
            }
        }
    }

    func unlikeProperty(userID: String, propertyID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let favoriteRef = db.collection("favorite").document("\(userID)_\(propertyID)")
        
        favoriteRef.delete { error in
            if let error = error {
                print(#function, "Failed to unlike property: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                print(#function, "Property unliked successfully")
                
                self.fetchFavoritesByUserID(userID: userID) { result in
                    switch result {
                        case .success(_):
                            completion(.success(()))
                        case .failure(let error):
                            completion(.failure(error))
                    }
                }
            }
        }
    }
    
    func toggle(userID: String, propertyID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        self.contains(userID: userID, propertyID: propertyID) { isLiked in
            if isLiked {
                self.unlikeProperty(userID: userID, propertyID: propertyID, completion: completion)
            } else {
                self.likeProperty(userID: userID, propertyID: propertyID, completion: completion)
            }
        }
    }

    func contains(userID: String, propertyID: String, completion: @escaping (Bool) -> Void) {
        let favoriteRef = db.collection("favorite").document("\(userID)_\(propertyID)")
        
        favoriteRef.getDocument { document, error in
            if let error = error {
                print(#function, "Failed to check favorite status: \(error.localizedDescription)")
                completion(false)
                return
            }
            completion(document?.exists ?? false)
        }
    }

    func unlikeMultipleProperties(userID: String, propertyIDs: [String], completion: @escaping (Result<Void, Error>) -> Void) {
        let batch = db.batch()
        
        for propertyID in propertyIDs {
            let favoriteRef = db.collection("favorite").document("\(userID)_\(propertyID)")
            batch.deleteDocument(favoriteRef)
        }
        
        batch.commit { error in
            if let error = error {
                print(#function, "Failed to unlike multiple properties: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                print(#function, "Successfully unliked multiple properties")
                
                
                self.fetchFavoritesByUserID(userID: userID) { result in
                    switch result {
                        case .success(_):
                            completion(.success(()))
                        case .failure(let error):
                            completion(.failure(error))
                    }
                }
            }
        }
    }
    
    func fetchFavoritesByUserID(userID: String, completion: @escaping (Result<[String]?, Error>) -> Void = { _ in }) {
        db.collection("favorite")
            .whereField("userID", isEqualTo: userID)
            .getDocuments { snapshot, error in
                if let error = error {
                    print(#function, "Error fetching favorites: \(error.localizedDescription)")
                    completion(.failure(error))
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    completion(.success([]))
                    return
                }
                
                let favoriteIDs = documents.compactMap { $0.data()["propertyID"] as? String }
                self.favoriteIDs = favoriteIDs
                completion(.success(favoriteIDs))
            }
    }
    
    private func fetchPropertiesByIDs(propertyIDs: [String], completion: @escaping (Result<[Property], Error>) -> Void) {
        guard !propertyIDs.isEmpty else {
            completion(.success([]))
            return
        }
        
        db.collection("property")
            .whereField(FieldPath.documentID(), in: propertyIDs)
            .getDocuments { snapshot, error in
                if let error = error {
                    print(#function, "Error fetching properties: \(error.localizedDescription)")
                    completion(.failure(error))
                    return
                }
                
                let properties = snapshot?.documents.compactMap { try? $0.data(as: Property.self) } ?? []
                completion(.success(properties))
            }
    }
}
