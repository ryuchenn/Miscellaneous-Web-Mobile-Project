//
//  CityBikeApp.swift
//  CityBike
//
//  Created by admin on 2025-03-12.
//

import SwiftUI
import Firebase

@main
struct CityBikeApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}























