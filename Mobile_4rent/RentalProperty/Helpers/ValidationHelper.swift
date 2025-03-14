//
//  ValidateHelper.swift
//  RentalProperty
//
//  Created by joeyin on 2025/2/9.
//

import Foundation

class ValidationHelper {
    static func check(name: String, value: String?, debug: Bool = false) -> String? {
        
        // Check if the value is empty
        guard let v = value, !v.isEmpty else {
            return ("\(name) is required.")
        }
        
        // Check the email format
        if name == "Email" {
            let emailRegex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
            let isValidEmail = NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: v)
            
            guard isValidEmail else {
                return "Invalid email format."
            }
        }
        
        if name == "Price" || name == "Sqft" {
            guard let value = value, let doubleValue = Double(value) else {
                return "Invalid value for \(name)."
            }
            
            guard doubleValue >= 0 else {
                return "\(name) should not be negative."
            }
            
            return nil
        }
        // For debugging
        debug ? print("\(name): \(v)") : ()
        
        return nil
    }
}
