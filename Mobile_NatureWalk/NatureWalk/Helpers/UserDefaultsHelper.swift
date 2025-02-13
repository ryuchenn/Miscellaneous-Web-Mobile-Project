//
//  UserDefaults.swift
//  NatureWalk
//
//  Created by joeyin on 2025/2/7.
//

import Foundation

enum Keys: String {
    case ACCOUNT
    case FAVORITES
    case LOGIN_FORM
}

class UserDefaultsHelper {
    static func get<T>(_ key: Keys) -> T? {
        return UserDefaults.standard.value(forKey: key.rawValue) as? T
    }
    
    static func set(_ key: Keys, _ value: Any?) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    static func remove(_ key: Keys) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
}
