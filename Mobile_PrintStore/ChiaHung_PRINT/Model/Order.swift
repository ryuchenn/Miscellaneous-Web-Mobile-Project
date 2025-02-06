//
//  Order.swift
//  ChiaHung_PRINT
//
//  Created by admin on 2025-02-05.
//
import Foundation

class Order: Identifiable, ObservableObject {
//    let id = UUID()
    @Published var type: String   // 1. Photo 2. Canvas
    @Published var size: String    // Photo: “4x6”, “6x8”, “8x12”  || Canvas: “12x16”, “16x20”, “18x24”
    @Published var quantity: Int
    @Published var name: String
    @Published var phone: String
    @Published var promotionCode: String // e.g., PRINT10, MEMORIES15
    @Published var discount: Double
    @Published var tax: Double
    @Published var total: Double
    @Published var deliveryCost: Double
    
    init(type: String, size: String, quantity: Int, name: String, phone: String, promotionCode: String, discount: Double, tax: Double, total: Double, deliveryCost: Double) {
        self.type = type
        self.size = size
        self.quantity = quantity
        self.name = name
        self.phone = phone
        self.promotionCode = promotionCode
        self.discount = discount
        self.tax = tax
        self.total = total
        self.deliveryCost = deliveryCost
    }
}

class PrintStore : ObservableObject{
    @Published var orders: [Order] = []
}
