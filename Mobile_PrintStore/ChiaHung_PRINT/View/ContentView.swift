//
//  ContentView.swift
//  ChiaHung_PRINT
//
//  Created by admin on 2025-02-05.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var orders = PrintStore()
    
    var body: some View {
        TabView{
            PrintSelection().tabItem{
                Label("Selection"  , systemImage: "bag.fill.badge.plus")
            }
            
            Receipt().tabItem{
                Label("Receipt"  , systemImage: "doc.on.clipboard")
            }
        }
        .environmentObject(self.orders)
    }
}

#Preview {
    ContentView()
}

