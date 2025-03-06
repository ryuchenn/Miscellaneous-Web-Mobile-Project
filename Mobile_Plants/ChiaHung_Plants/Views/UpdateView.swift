//
//  Update.swift
//  ChiaHung_Plants
//
//  Created by admin on 2025-03-05.
//

import SwiftUI
import CoreLocation
import MapKit

struct UpdateView: View {
    @State var plant: Plant
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var controller: PlantController
    
    @State private var plantName: String = ""
    @State private var selectedType: PlantType = .indoor
    @State private var selectedSize: PlantSize = .medium
    @State private var quantity: Int = 1
    @State private var imageURL: String = ""
    @State private var coordinate: CLLocationCoordinate2D? = nil
    @State private var showMapPicker = false
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
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
                
                TextField("Image URL (optional)", text: $imageURL)
                    .keyboardType(.URL)
                    .autocapitalization(.none)
                
                Button("Update Location") {
                    showMapPicker = true
                }
                if let coord = coordinate {
                    Text("Selected Location: \(coord.latitude), \(coord.longitude)")
                } else if let lat = plant.latitude, let lon = plant.longitude {
                    Text("Current Location: \(lat), \(lon)")
                } else {
                    Text("No location selected")
                }
            }
            
            Section {
                Button("Save") {
                    guard !plantName.trimmingCharacters(in: .whitespaces).isEmpty else {
                        alertMessage = "Plant Name cannot be empty."
                        showAlert = true
                        return
                    }
                    
                    plant.name = plantName
                    plant.type = selectedType
                    plant.size = selectedSize
                    plant.quantity = quantity
                    plant.url = imageURL.isEmpty ? nil : imageURL
                    if let coord = coordinate {
                        plant.latitude = coord.latitude
                        plant.longitude = coord.longitude
                    }
                    
                    controller.update(plant) { error in
                        if let error = error {
                            alertMessage = "Update failed: \(error.localizedDescription)"
                            showAlert = true
                        }else {
                            // Dismiss to previous page when data update to the database
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
        }
        .navigationBarTitle("Update", displayMode: .inline)
        .onAppear {
            plantName = plant.name
            selectedType = plant.type
            selectedSize = plant.size
            quantity = plant.quantity
            imageURL = plant.url ?? ""
            if let lat = plant.latitude, let lon = plant.longitude {
                coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
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

