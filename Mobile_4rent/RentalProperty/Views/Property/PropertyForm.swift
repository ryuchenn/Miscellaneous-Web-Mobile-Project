//
//  PropertyForm.swift
//  RentalProperty
//
//  Created by joeyin on 2025/3/10.
//

import SwiftUI

struct PropertyForm: View {
    // Required
    @Binding var address1: String
    @Binding var address2: String
    @Binding var city: String
    @Binding var province: String
    @Binding var country: String
    @Binding var postalCode: String
    @Binding var startDate: Date
    @Binding var minRentMonth: Int
    @Binding var price: String
    @Binding var type: RentType

    @Binding var propertyType: PropertyType
    @Binding var bedroom: Int
    @Binding var den: Int
    @Binding var bathroom: Int
    @Binding var parking: Int
    @Binding var sqft: String
    
    @Binding var pictureURLs: [String]
    @Binding var newPictureURL: String
    
    private func addPicture() {
        guard !newPictureURL.isEmpty else { return }
        pictureURLs.append(newPictureURL)
        newPictureURL = ""
    }
    
    private func removePicture(_ url: String) {
        pictureURLs.removeAll { $0 == url }
    }
    
    var body: some View {
        Form {
            Section("Address") {
                List {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Address")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        TextField("Required", text: $address1)
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Unit Number")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        TextField("Required", text: $address2)
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("City")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        TextField("Required", text: $city)
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Province")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        TextField("Required", text: $province)
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Country")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        TextField("Required", text: $country)
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Postal Code")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        TextField("Required", text: $postalCode)
                    }
                }
            }
            
            Section("Rental") {
                List {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Price")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        TextField("Required", text: $price)
                            .keyboardType(.decimalPad)
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Start Date")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        DatePicker("", selection: $startDate, displayedComponents: .date)
                            .foregroundColor(.black)
                            .labelsHidden()
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Minimum Rent Month")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Menu {
                            Picker("", selection: $minRentMonth) {
                                ForEach(1...12, id: \.self) { Text("\($0)") }
                            }
                        } label: {
                            HStack(spacing: 5) {
                                Text(IntegerFormatter(Double(minRentMonth)))
                                Image(systemName: "chevron.up.chevron.down")
                            }
                        }
                        .foregroundColor(.black)
                        .labelsHidden()
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Type")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Menu {
                            Picker("", selection: $type) {
                                ForEach(RentType.allCases, id: \.self) { rentType in
                                    Text(rentType.rawValue).tag(rentType)
                                }
                            }
                        } label: {
                            HStack(spacing: 5) {
                                Text(type.rawValue)
                                Image(systemName: "chevron.up.chevron.down")
                            }
                        }
                        .foregroundColor(.black)
                        .labelsHidden()
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Property Type")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Menu {
                            Picker("", selection: $propertyType) {
                                ForEach(PropertyType.allCases, id: \.self) { propertyType in
                                    Text(propertyType.rawValue).tag(propertyType)
                                }
                            }
                        } label: {
                            HStack(spacing: 5) {
                                Text(propertyType.rawValue)
                                Image(systemName: "chevron.up.chevron.down")
                            }
                        }
                        .foregroundColor(.black)
                        .labelsHidden()
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Bedroom")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Stepper(
                            IntegerFormatter(Double(bedroom)),
                            value: $bedroom,
                            in: 1...5
                        )
                        .frame(width: 120)
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Den")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Stepper(
                            IntegerFormatter(Double(den)),
                            value: $den,
                            in: 0...5
                        )
                        .frame(width: 120)
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Bathroom")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Stepper(
                            IntegerFormatter(Double(bathroom)),
                            value: $bathroom,
                            in: 1...5
                        )
                        .frame(width: 120)
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Parking")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Stepper(
                            IntegerFormatter(Double(parking)),
                            value: $parking,
                            in: 0...5
                        )
                        .frame(width: 120)
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Sqft")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        TextField("Required", text: $sqft)
                            .keyboardType(.decimalPad)
                    }
                }
            }
            
            Section("Additional") {
                List {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Pictures")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        ForEach(pictureURLs, id: \.self) { url in
                            HStack {
                                Text(url)
                                    .lineLimit(1)
                                    .truncationMode(.middle)
                                
                                Spacer()
                                
                                Button(action: { removePicture(url) }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                        .padding(.vertical, 10)
                            
                        HStack {
                            TextField("Enter Picture URL", text: $newPictureURL)
                            
                            Spacer()
                            
                            Button(action: addPicture) {
                                Image(systemName: "plus.circle.fill")
                            }
                        }
                    }
                    
                }
            }
        }
    }
}
