//
//  ContentView.swift
//  NatureWalk
//
//  Created by joeyin on 2025/1/27.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            if AccountService.isLoggedIn() {
                TabView() {
                    SessionView().tabItem{
                        Label("Sessions", systemImage: "square.grid.2x2.fill")
                    }
                    .tag(0)
                    
                    FavoriteView().tabItem{
                        Label("Favorites", systemImage: "star.fill")
                    }
                    .tag(1)
                }
            } else {
                LoginView()
            }
        }
    }
}

#Preview {
    ContentView()
}
