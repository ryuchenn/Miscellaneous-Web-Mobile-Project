//
//  Session.swift
//  NatureWalk
//
//  Created by admin on 2025-02-06.
//

import Foundation

struct Session: Identifiable, Hashable {
    let id: Int
    var name: String
    var date: Date
    var address: String
    var description: String
    var rating: Double
    var hosting: String
    var photos: [String]
    var price: Double
    var phone: String
}
