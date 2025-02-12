//
//  constant.swift
//  ChiaHung_Final
//
//  Created by admin on 2025-02-11.
//

import Foundation

let datePicker: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()

enum shipStatus: String {
    case inTransit = "In Transit"
    case delivered = "Delivered"
}

let carriers = ["FedEx", "UPS", "DHL"]

