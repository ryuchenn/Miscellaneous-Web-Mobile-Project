//
//  Plant.swift
//  ChiaHung_Plants
//
//  Created by admin on 2025-03-05.
//

import Foundation

enum PlantType: String, Codable {
    case indoor = "Indoor"
    case outdoor = "Outdoor"
    
    // Setting the Insert, Update value
    static var all: [PlantType] {
        return [.indoor, .outdoor]
    }
}

enum PlantSize: String, Codable {
    case small = "Small"
    case medium = "Medium"
    case large = "Large"
    
    // Setting the Insert, Update value
    static var all: [PlantSize] {
        return [.small, .medium, .large]
    }
}

struct Plant: Identifiable, Codable {
    var id: String = UUID().uuidString
    var name: String              // (Required）
    var type: PlantType = .indoor // Indoor, Outdoor
    var size: PlantSize = .medium // Small, Medium, Large
    var quantity: Int = 1         // 1~10
    var latitude: Double? = nil
    var longitude: Double? = nil
    var url: String? = nil       // (Optional)
}
