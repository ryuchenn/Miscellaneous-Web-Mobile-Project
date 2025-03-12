//
//  ContentView.swift
//  CityBike
//
//  Created by admin on 2025-03-12.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            BikeListView()
                .tabItem {
                    Label("Locations", systemImage: "list.dash")
                }
            BikeMapView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }
            FavoriteListView()
                .tabItem {
                    Label("Favorites", systemImage: "star.fill")
                }
        }
    }
}

#Preview {
    ContentView()
}
