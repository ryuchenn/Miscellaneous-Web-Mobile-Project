//
//  Property.swift
//  RentalProperty
//
//  Created by admin on 2025-03-07.
//

import Foundation
import FirebaseFirestore

struct Property: Identifiable, Codable {
    @DocumentID var id: String?
    // Required
    var address1: String
    var address2: String
    var city: String
    var province: String
    var country: String
    var postalCode: String
    
    var price: Double
    var startDate: Date
    var minRentMonth: Int
    var type: String
    var propertyType: String
    var bedroom: Int
    var den: Int
    var bathroom: Int
    var parking: Int
    var sqft: Double
    
    // Optional
    var pictureURL: [String]?
    var communityName: String?
    var description: String?
    var latitude: Double?
    var longitude: Double?
    var area: String?
    var amenities: [String]?
    var exposure: String?
    var included: [String]?
    var prohibited: [String]?
    var gender: String?

    var contactID: String // Landlord, Agent, etc.
    var createAt: Date
    var logUser: String
    var logDate: Date

    static let initValue = Property(
        id: nil,
        address1: "",
        address2: "",
        city: "",
        province: "",
        country: "",
        postalCode: "",
        price: 0.0,
        startDate: Date(),
        minRentMonth: 1,
        type: "Rent",
        propertyType: "Apartment",
        bedroom: 1,
        den: 0,
        bathroom: 1,
        parking: 0,
        sqft: 0.0,
        pictureURL: [],
        communityName: "",
        description: "",
        latitude: nil,
        longitude: nil,
        area: "",
        amenities: [],
        exposure: "",
        included: [],
        prohibited: [],
        gender: "None",
        contactID: "",
        createAt: Date(),
        logUser: "",
        logDate: Date()
    )
}
