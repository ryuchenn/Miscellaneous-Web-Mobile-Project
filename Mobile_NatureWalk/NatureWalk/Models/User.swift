//
//  User.swift
//  NatureWalk
//
//  Created by admin on 2025-02-06.
//

import Foundation

struct User: Codable, Identifiable {
    var id: Int
    var email: String
    var name: String
    var password: String?
}
