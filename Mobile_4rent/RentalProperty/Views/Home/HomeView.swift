//
//  HomeView.swift
//  RentalProperty
//
//  Created by joeyin on 2025/3/6.
//

import SwiftUI

struct HomeView: View {
    @State var searchKeyword: String = ""
    @State var searchPropertyType: PropertyType?
    @State var properties = [Property]()
    
    @EnvironmentObject var accountController: AccountController
    @EnvironmentObject var propertyController: PropertyController
    @EnvironmentObject var favoriteController: FavoriteController
    
    @State var result = [Property]()
    @Binding var selectedTab: Int
    
    func onAppear() {
        if propertyController.properties.isEmpty {
            propertyController.all() { result in
                if case .success = result {
                    self.result = propertyController.properties
                }
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                HeaderSearchBar(
                    defaultItems: propertyController.properties,
                    result: $result
                )
                
                ForEach(result) { property in
                    PropertyCard(property: property)
                }
            }
            .navigationBarTitle("Discover")
            .background(Color.lightGray)
            .navigationBarItems(trailing: AvatarView(selectedTab: $selectedTab).environmentObject(accountController))
            .onAppear{
                onAppear()
            }
        }
    }
}

#Preview {
    var selectedTab: Int = 0
    
    HomeView(selectedTab: .constant(selectedTab))
}
