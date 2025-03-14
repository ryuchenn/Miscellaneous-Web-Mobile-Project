//
//  FormatHelper.swift
//  INVETKER
//
//  Created by joeyin on 2025/3/7.
//

import SwiftUI

func DecimalFormatter(_ value: Double?) -> String {
    if value == nil {
        return "-"
    }
    
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 2
    formatter.minimumFractionDigits = 2
    return formatter.string(from: NSNumber(value: value!)) ?? ""
}

func IntegerFormatter(_ value: Double?) -> String {
    if value == nil {
        return "-"
    }
    
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 0
    return formatter.string(from: NSNumber(value: value!)) ?? ""
}

func DateFormatter(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return formatter.string(from: date)
}
