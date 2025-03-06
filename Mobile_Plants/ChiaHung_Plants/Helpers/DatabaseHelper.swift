//
//  DatabaseHelper.swift
//  ChiaHung_Plants
//
//  Created by admin on 2025-03-05.
//
import Foundation
import Firebase
import FirebaseFirestore

struct DictionaryEncoder {
    static func encode<T: Encodable>(_ value: T) throws -> [String: Any] {
        let data = try JSONEncoder().encode(value)
        let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
        guard let dict = jsonObject as? [String: Any] else {
            throw NSError(domain: "EncodingError", code: -1, userInfo: nil)
        }
        return dict
    }
}

struct DictionaryDecoder {
    static func decode<T: Decodable>(_ type: T.Type, from dict: [String: Any]) throws -> T {
        let data = try JSONSerialization.data(withJSONObject: dict, options: [])
        return try JSONDecoder().decode(T.self, from: data)
    }
}

class DatabaseHelper {
    static let instance = DatabaseHelper()
    let db = Firestore.firestore()
        func add(_ plant: Plant, completion: @escaping (Error?) -> Void) {
        do {
            let data = try DictionaryEncoder.encode(plant)
            db.collection("plants").document(plant.id).setData(data) { error in
                completion(error)
            }
        } catch {
            completion(error)
        }
    }
    
    // get all data
    func get(completion: @escaping ([Plant]) -> Void) {
        db.collection("plants").getDocuments { snapshot, error in
            var plants = [Plant]()
            if let docs = snapshot?.documents {
                for doc in docs {
                    do {
                        let plant = try DictionaryDecoder.decode(Plant.self, from: doc.data())
                        plants.append(plant)
                    } catch {
                        print("Decoding error: \(error)")
                    }
                }
            }
            completion(plants)
        }
    }
    
    func delete(_ plant: Plant, completion: @escaping (Error?) -> Void) {
        db.collection("plants").document(plant.id).delete { error in
            completion(error)
        }
    }
    
    func update(_ plant: Plant, completion: @escaping (Error?) -> Void) {
        do {
            let data = try DictionaryEncoder.encode(plant)
            db.collection("plants").document(plant.id).setData(data, merge: true) { error in
                completion(error)
            }
        } catch {
            completion(error)
        }
    }
    
    // check the collection "discounts" and the inside value is exist or not
    func validate(_ code: String, completion: @escaping (Bool) -> Void) {
        db.collection("discounts").document(code).getDocument { snapshot, error in
            if let snapshot = snapshot, snapshot.exists {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}
