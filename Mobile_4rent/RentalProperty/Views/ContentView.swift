//
//  ContentView.swift
//  RentalProperty
//
//  Created by joeyin on 2025/3/4.
//

import SwiftUI

struct ContentView: View {   
    @StateObject private var accountController = AccountController.getInstance()
    @StateObject private var propertyController = PropertyController.getInstance()
    @StateObject private var favoriteController = FavoriteController.getInstance()
    @StateObject private var requestHelper = RequestController.getInstance()
    @State private var selectedTab: Int = 0
        
    init() {
        let primaryColor = UIColor(Color("AccentColor"))
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = primaryColor
        appearance.shadowColor = nil
        appearance.shadowImage = UIImage(named: "shadow")
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        // Back Button Text, Color and Image
        // Ref: https://developer.apple.com/forums/thread/709517
        let backImage = UIImage(systemName: "chevron.backward")?.withRenderingMode(.alwaysOriginal).withTintColor(.white)
        appearance.setBackIndicatorImage(backImage, transitionMaskImage: backImage)
        let backItemAppearance = UIBarButtonItemAppearance()
        backItemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backButtonAppearance = backItemAppearance

        let navBar = UINavigationBar.appearance()
        navBar.standardAppearance = appearance
        navBar.scrollEdgeAppearance = appearance
        navBar.compactAppearance = appearance
        navBar.tintColor = .white
    }
    
    var body: some View {        
        TabView(selection: $selectedTab) {
            HomeView(selectedTab: $selectedTab)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            
            MapView()
                .tabItem {
                    Label("Map", systemImage: "map.fill")
                }
                .tag(1)
            
            EditPropertyView(action: .Create)
                .tabItem {
                    Label("Post", systemImage: "plus.app.fill")
                }
                .tag(2)
            FavoriteView()
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }
                .tag(3)
            
            AccountView()
                .tabItem {
                    Label("Account", systemImage: "person.fill")
                }
                .tag(4)
        }
        .environmentObject(accountController)
        .environmentObject(propertyController)
        .environmentObject(favoriteController)
        .environmentObject(requestHelper)
        .onChange(of: accountController.user?.uid) {
            if let userID = accountController.user?.uid {
                favoriteController.fetchFavoritesByUserID(userID: userID)
            } else {
                favoriteController.favoriteIDs = []
            }
        }
    }
    
}

#Preview {
    ContentView()
}
