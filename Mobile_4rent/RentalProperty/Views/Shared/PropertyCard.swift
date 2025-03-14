//
//  PropertyCardView.swift
//  RentalProperty
//
//  Created by joeyin on 2025/3/12.
//

import SwiftUI

struct PropertyCard: View {
    @EnvironmentObject var accountController: AccountController
    @EnvironmentObject var propertyController: PropertyController
    @EnvironmentObject var favoriteController: FavoriteController
    
    let property: Property
    
    var body: some View {
        VStack {
            NavigationLink(
                destination: PropertyDetailView(property: property)
                    .environmentObject(accountController)
                    .environmentObject(propertyController)
                    .environmentObject(favoriteController)
            ) {
                HStack {
                    ZStack {
                        PropertyPhoto(property: property)
                        PropertyBadgeView(property: property)
                    }
                }
                
                PropertyDetail(property: property)
            }
            .padding(.horizontal)
            .padding(.vertical, 0)
            
            Divider()
                .frame(maxWidth: .infinity)
                .background(Color("TealBlueHoverColor"))
        }
    }
}
