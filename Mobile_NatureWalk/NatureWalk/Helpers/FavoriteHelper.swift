//
//  FavoriteHelper.swift
//  NatureWalk
//
//  Created by joeyin on 2025/2/8.
//

import Foundation

class FavoriteHelper {
    static func all() -> [Favorite] {
        var favorites = [Favorite]()

        let value: Data = UserDefaultsHelper.get(.FAVORITES) ?? Data()

        if let decoded = try? JSONDecoder().decode([Favorite].self, from: value) {
            favorites = decoded
        }
        
        return favorites
    }
    
    static func add(_ id: Int) -> [Favorite] {
        var favorites = all()
  
        favorites.append(
            Favorite(
                userId: AccountService.id(),
                sessionId: id
            )
        )
        
        if let encodedData = try? JSONEncoder().encode(favorites) {
            UserDefaultsHelper.set(.FAVORITES, encodedData)
        }
        
        return all()
    }
    
    static func remove(_ id: Int) -> [Favorite] {
        var favorites = all()
        
        favorites.removeAll { $0.sessionId == id && $0.userId == AccountService.id() }
        
        if let encodedData = try? JSONEncoder().encode(favorites) {
            UserDefaultsHelper.set(.FAVORITES, encodedData)
        }
        
        return all()
    }
    
    static func toggle(_ id: Int) -> [Favorite] {
        if contains(id) {
            return remove(id)
        } else {
            return add(id)
        }
    }
    
    static func contains(_ id: Int) -> Bool {
        return all().contains { $0.sessionId == id && $0.userId == AccountService.id() }
    }
}
