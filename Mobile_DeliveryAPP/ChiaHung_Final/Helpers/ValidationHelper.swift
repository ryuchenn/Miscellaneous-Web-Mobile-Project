//
//  ValidationHelper.swift
//  ChiaHung_Final
//
//  Created by admin on 2025-02-11.
//
import Foundation

class ValidationHelper {
    static func check(name: String, value: String?, debug: Bool = false) -> String? {
        
        // Check if the value is empty
        guard let v = value, !v.isEmpty else {
            return ("\(name) is required.")
        }
        
        return nil
    }
}
