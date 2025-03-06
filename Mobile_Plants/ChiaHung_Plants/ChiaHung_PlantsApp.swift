//
//  ChiaHung_PlantsApp.swift
//  ChiaHung_Plants
//
//  Created by admin on 2025-03-05.
//

import SwiftUI
import Firebase
import FirebaseFirestore

@main
struct ChiaHung_PlantsApp: App {
    @StateObject var controller = PlantController()
    
    init() {
        FirebaseApp.configure() // BundID: ChiaHung.ChiaHung-Plants
    }
    
    var body: some Scene {
        WindowGroup {
            MainView(controller: controller)
        }
    }
}
