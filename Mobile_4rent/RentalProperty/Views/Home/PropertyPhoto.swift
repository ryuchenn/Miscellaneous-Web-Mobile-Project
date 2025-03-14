//
//  PropertyPhoto.swift
//  RentalProperty
//
//  Created by joeyin on 2025/3/10.
//

import SwiftUI

struct PropertyPhoto: View {
    let property: Property
    var width = 175 as CGFloat
    var height = 140 as CGFloat
    var cornerRadius = 6 as CGFloat
    
    var body: some View {
        VStack {
            if let image = property.pictureURL?.first {
                ImageLoader(url: image, width: width, height: height)
                    .clipped()
                    .cornerRadius(cornerRadius)
            } else {
                Image("Brand")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 110, height: 100)
                    .opacity(0.3)
            }
        }
        .frame(width: width, height: height)
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(Color("TealBlueHoverColor").opacity(0.5), lineWidth: 1)
        )
    }
}
