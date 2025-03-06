//
//  InsertView.swift
//  ChiaHung_Plants
//
//  Created by admin on 2025-03-05.
//


import SwiftUI
import CoreLocation
import MapKit

struct InsertView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var plantName: String = ""
    @State private var selectedType: PlantType = .indoor
    @State private var selectedSize: PlantSize = .medium
    @State private var quantity: Int = 1
    @State private var discountCode: String = ""
    @State private var imageURL: String = ""

    @State private var showAlert = false
    @State private var alertMessage = ""
    
    // Location Related
    @State private var coordinate: CLLocationCoordinate2D? = nil
    @State private var showMapPicker = false
    
    @ObservedObject var controller: PlantController
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Details")) {
                    TextField("Name", text: $plantName)
                        .autocapitalization(.words)
                    
                    Picker("Type", selection: $selectedType) {
                        ForEach(PlantType.all, id: \.self) { type in
                            Text(type.rawValue)
                        }
                    }
                    
                    Picker("Size", selection: $selectedSize) {
                        ForEach(PlantSize.all, id: \.self) { size in
                            Text(size.rawValue)
                        }
                    }
                    
                    Stepper("Quantity: \(quantity)", value: $quantity, in: 1...10)
                    
                    TextField("Coupon Code (optional)", text: $discountCode)
                        .autocapitalization(.allCharacters)
                    
                    TextField("Image URL (optional)", text: $imageURL)
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                    
                    Button("Add Location") {
                        showMapPicker = true
                    }
                    
                    // select the coordinate if user already choosen it.
                    if let coord = coordinate {
                        Text("Selected Location: \(coord.latitude), \(coord.longitude)")
                            .font(.subheadline)
                    }
                }
                
                Section {
                    Button("Add to Nursery") {
                        // Validate Name Field
                        guard !plantName.trimmingCharacters(in: .whitespaces).isEmpty else {
                            alertMessage = "Plant Name cannot be empty."
                            showAlert = true
                            return
                        }
                        
                        // Validate Coupon Field
                        if !discountCode.trimmingCharacters(in: .whitespaces).isEmpty {
                            DatabaseHelper.instance.validate(discountCode) { isValid in
                                if isValid {
                                    addData()
                                } else {
                                    alertMessage = "Invalid discount code."
                                    showAlert = true
                                }
                            }
                        } else {
                            // If not enter the coupon code
                            addData()
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(
                Image("backgroundImage")
                    .edgesIgnoringSafeArea(.all)
                    .overlay(Color.white.opacity(0.7))
            )
            .sheet(isPresented: $showMapPicker) {
                NavigationView {
                    MapView(coordinate: $coordinate)
                        .navigationBarTitle("Select Location", displayMode: .inline)
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Alert"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private func addData() {
        let newPlant = Plant(
            name: plantName,
            type: selectedType,
            size: selectedSize,
            quantity: quantity,
            latitude: coordinate?.latitude,
            longitude: coordinate?.longitude,
            url: imageURL.isEmpty ? nil : imageURL
        )
        
        controller.add(newPlant) { error in
            if let error = error {
                alertMessage = "Failed to add plant: \(error.localizedDescription)"
                showAlert = true
            } else {
                // Dismiss to previous page when data added to the database
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}
