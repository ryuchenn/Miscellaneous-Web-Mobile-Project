//
//  PropertyBadgeView.swift
//  RentalProperty
//
//  Created by joeyin on 2025/3/10.
//

import SwiftUI

struct PropertyBadgeView: View {
    let property: Property
    
    var body: some View {
        VStack {
            Text(property.propertyType)
                .font(.system(size: 11))
                .padding(.vertical, 3)
                .padding(.horizontal, 6)
                .background(Color("OrangeColor"))
                .foregroundColor(.white)
                .cornerRadius(2)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 3)
        .frame(width: 160, height: 140, alignment: .topLeading)
    }
}
