//
//  Netwrok.swift
//  CityBike
//
//  Created by admin on 2025-03-12.
//

import Foundation

/// Model representing a city bike network
struct DataField: Identifiable, Codable {
    let id: String
    let name: String
    let location: Location
    let href: String
    let company: [String]
    let gbfs_href: String?
}

/// Decoding data from the API
struct DataFields: Codable {
    let networks: [DataField]
}
