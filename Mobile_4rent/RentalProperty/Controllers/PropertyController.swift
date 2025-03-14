//
//  AccountHelper.swift
//  RentalProperty
//
//  Created by joeyin on 2025/3/11.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class PropertyController: ObservableObject {
    private static var shared : PropertyController?
    private var db = Firestore.firestore()
    
    @Published var properties: [Property] = []
    
    init(db: Firestore) {
        self.db = db
    }
    
    static func getInstance() -> PropertyController {
        if (shared == nil) {
            shared = PropertyController(db: Firestore.firestore())
        }
        
        return shared!
    }
    
    func all(completion: @escaping (Result<[Property]?, Error>) -> Void = { _ in }) {
        db.collection("property").getDocuments { snapshot, error in
            if let error = error {
                print(#function, "Error fetching properties: \(error.localizedDescription)")
                return completion(.failure(error))
            }
            
            guard let documents = snapshot?.documents else {
                return completion(.success(nil))
            }
            
            let properties = documents.compactMap { doc -> Property? in
                try? doc.data(as: Property.self)
            }
            
            self.properties = properties
            completion(.success(properties))
        }
    }
    
    func addProperty(propertyData: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("property").addDocument(data: propertyData) { error in
            if let error = error {
                print(#function, "Failed to add property: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                print(#function, "Property added successfully")
                self.all()
                completion(.success(()))
            }
        }
    }
    
    func fetchByContactID(uid: String, completion: @escaping (Result<[Property], Error>) -> Void) {
        db.collection("property")
            .whereField("contactID", isEqualTo: uid)
            .getDocuments { snapshot, error in
                if let error = error {
                    print(#function, "Error fetching properties: \(error.localizedDescription)")
                    completion(.failure(error))
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    completion(.success([]))
                    return
                }
                
                let properties = documents.compactMap { doc -> Property? in
                    try? doc.data(as: Property.self)
                }
                
                completion(.success(properties))
            }
    }
    
    func fetchByPropertyID(propertyID: String, completion: @escaping (Result<Property, Error>) -> Void) {
        db.collection("property").document(propertyID).getDocument { document, error in
            if let error = error {
                print(#function, "Error fetching property: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let document = document, document.exists else {
                completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Property not found"])))
                return
            }
            
            if let property = try? document.data(as: Property.self) {
                completion(.success(property))
            } else {
                completion(.failure(NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to decode property"])))
            }
        }
    }
    
    func updateProperty(propertyID: String, propertyData: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
        let propertyRef = db.collection("property").document(propertyID)

        propertyRef.updateData(propertyData) { error in
            if let error = error {
                print(#function, "Failed to update property: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                print(#function, "Property updated successfully")
                self.all()
                completion(.success(()))
            }
        }
    }

    func deleteProperty(propertyID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("property").document(propertyID).delete { error in
            if let error = error {
                print(#function, "Failed to delete property: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                print(#function, "Property deleted successfully")
                
                self.all()
                completion(.success(()))
            }
        }
    }
    
    func deleteMultipleProperties(propertyIDs: [String], completion: @escaping (Result<Void, Error>) -> Void) {
        let batch = db.batch()

        for propertyID in propertyIDs {
            let propertyRef = db.collection("property").document(propertyID)
            batch.deleteDocument(propertyRef)
        }

        batch.commit { error in
            if let error = error {
                print(#function, "Failed to delete multiple properties: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                print(#function, "Successfully deleted multiple properties")
                
                self.all() { result in
                    switch result {
                        case .success:
                            completion(.success(()))
                        case .failure(let error):
                            completion(.failure(error))
                    }
                }
            }
        }
    }
}
