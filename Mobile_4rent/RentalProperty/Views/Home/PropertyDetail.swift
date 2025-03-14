//
//  PropertyDetail.swift
//  RentalProperty
//
//  Created by joeyin on 2025/3/10.
//

import SwiftUI

struct PropertyDetail: View {
    let property: Property
    
    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            Text(property.communityName?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "-")
                .font(.system(size: 16))
                .fontWeight(.semibold)
                .lineLimit(1)
            
            HStack(spacing: 6) {
                HStack {
                    Image(systemName: "bed.double.fill")
                        .font(.system(size: 12))
                        .frame(width: 16, height: 16)
                        .foregroundColor(Color("DarkBlueColor"))

                    Text(IntegerFormatter(Double(property.bedroom)))
                        .font(.system(size: 13))
                }

                HStack {
                    Image(systemName: "shower.fill")
                        .font(.system(size: 14))
                        .frame(width: 16, height: 16)
                        .foregroundColor(Color("DarkBlueColor"))

                    Text(IntegerFormatter(Double(property.bathroom)))
                        .font(.system(size: 13))
                }
                
                HStack {
                    Image(systemName: "car.fill")
                        .font(.system(size: 14))
                        .frame(width: 16, height: 16)
                        .foregroundColor(Color("DarkBlueColor"))

                    Text(IntegerFormatter(Double(property.parking)))
                        .font(.system(size: 13))
                }
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text("\(property.province), \(property.country)")
                    .font(.system(size: 14))
                    .fontWeight(.bold)
                    .foregroundColor(Color.accentColor)
                    .lineLimit(1)

                Text("\(property.city), \(property.province)")
                    .font(.system(size: 14))
                    .fontWeight(.bold)
                    .foregroundColor(Color("BluishGreyColor"))
                
                Text(property.address1)
                    .font(.system(size: 14))
                    .foregroundColor(Color("BluishGreyColor"))
            }
            
            Text("$\(DecimalFormatter(property.price))")
                .font(.system(size: 17))
                .fontWeight(.bold)
        }
        .padding(.leading, 10)
        .padding(.vertical, 10)
        .foregroundColor(.black)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    }
}
