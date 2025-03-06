//
//  DetailView.swift
//  ChiaHung_Plants
//
//  Created by admin on 2025-03-05.
//
import SwiftUI

struct DetailView: View {
    let plantID: String
    
    var plant: Plant? {
        controller.plants.first { $0.id == plantID }
    }
    @ObservedObject var controller: PlantController
    
    @State private var showMapAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            if let plant = plant {
            } else {
                Text("Plant not found.")
            }
            
            HStack{
                Spacer()
                if let urlString = plant?.url, let url = URL(string: urlString) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(height: 200)
                }
                Spacer()
            }
            
            
            HStack {
                Image(systemName: "leaf")
                Text("Name: \(plant?.name ?? "")")
            }

            HStack {
                Image(systemName: "square.grid.2x2")
                Text("Type: \(plant?.type.rawValue ?? "")")
            }

            HStack {
                Image(systemName: "ruler")
                Text("Size: \(plant?.size.rawValue ?? "")")
            }

            HStack {
                Image(systemName: "number")
                Text("Quantity: \(plant?.quantity ?? 1)")
            }

            HStack {
                Button(action: {
                    if let lat = plant?.latitude, let lon = plant?.longitude {
                        let urlString = "http://maps.apple.com/?ll=\(lat),\(lon)"
                        if let url = URL(string: urlString) {
                            UIApplication.shared.open(url)
                        }
                    } else {
                        showMapAlert = true
                    }
                }) {
                    Image(systemName: "map")
                        .font(.title)
                }
                .alert(isPresented: $showMapAlert) {
                    Alert(title: Text("Alert"), message: Text("You have not provided location coordinates."), dismissButton: .default(Text("OK")))
                }
                
                if let lat = plant?.latitude, let lon = plant?.longitude {
                    Text("Location: \(lat), \(lon)")
                } else {
                    Text("Location: Not provided")
                }
                Spacer()
            }
            Spacer()
            
        }
        .onAppear {
            controller.loadData()
        }
        .scrollContentBackground(.hidden)
        .background(
            Image("backgroundImage")
                .edgesIgnoringSafeArea(.all)
                .overlay(Color.white.opacity(0.7))
        )
        .padding()
        .navigationBarTitle("Details", displayMode: .inline)
        .navigationBarItems(trailing:
            Group {
                if let unwrappedPlant = plant {
                    NavigationLink("Update", destination: UpdateView(plant: unwrappedPlant, controller: controller))
                } else {
                    Text("Plant data not available")
                }
            }
        )
    }
}
