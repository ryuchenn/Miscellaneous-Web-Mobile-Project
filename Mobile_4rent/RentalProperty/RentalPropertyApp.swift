//
//  RentalPropertyApp.swift
//  RentalProperty
//
//  Created by joeyin on 2025/3/4.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

// firebase dependency
// https://github.com/firebase/firebase-ios-sdk

@main
struct RentalPropertyApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
