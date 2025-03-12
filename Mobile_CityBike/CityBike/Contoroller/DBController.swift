//
//  FirebaseController.swift
//  CityBike
//
//  Created by admin on 2025-03-12.
//

import Foundation
import Firebase
import FirebaseFirestore

/// For Firebase operations.
class DBController {
    private let db = Firestore.firestore()
    private let fav = "favorites"
    
    func add(net: DataField, completion: @escaping (Error?) -> Void) {
        db.collection(fav).document(net.id).getDocument { doc, err in
            if let doc = doc, doc.exists {
                // Already exists, no action taken
                completion(nil)
            } else {
                do {
                    try self.db.collection(self.fav).document(net.id).setData(from: net) { err in
                        completion(err)
                    }
                } catch {
                    completion(error)
                }
            }
        }
    }
    
    func fetch(completion: @escaping ([DataField]?, Error?) -> Void) {
        db.collection(fav).getDocuments { snap, err in
            if let err = err {
                completion(nil, err)
            } else {
                let nets = snap?.documents.compactMap { try? $0.data(as: DataField.self) }
                completion(nets, nil)
            }
        }
    }
    
    func delete(net: DataField, completion: @escaping (Error?) -> Void) {
        db.collection(fav).document(net.id).delete { err in
            completion(err)
        }
    }
}
