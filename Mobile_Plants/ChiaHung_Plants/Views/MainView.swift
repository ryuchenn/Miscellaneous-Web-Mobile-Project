//
//  MainView.swift
//  ChiaHung_Plants
//
//  Created by admin on 2025-03-05.
//
import SwiftUI

struct CardView: View {
    var plant: Plant
    
    var body: some View {
         VStack(spacing: 0) {
              if let urlString = plant.url, let url = URL(string: urlString) {
                 AsyncImage(url: url) { image in
                     image
                         .resizable()
                         .aspectRatio(contentMode: .fill)
                 } placeholder: {
                     Color.gray.opacity(0.3)
                 }
                 .frame(height: 150)
                 .clipped()
              } else {
                  // If user didn't provide any imageURL, it will only show leaf
                  Image(systemName: "leaf")
                     .resizable()
                     .aspectRatio(contentMode: .fit)
                     .frame(height: 150)
                     .foregroundColor(.green)
                     .padding()
              }
              Divider()
              HStack{
                  Image(systemName: "leaf")
                  Text(plant.name)
                     .font(.headline)
                     .padding(8)
              }
              
         }
         .background(Color.white)
         .cornerRadius(10)
         .shadow(radius: 5)
         .padding(5)
    }
}

struct MainView: View {
    @ObservedObject var controller: PlantController
    
    // indoor filter
    var indoorPlants: [Plant] {
        controller.plants.filter { $0.type == .indoor }
    }
    
    // outdoor filter
    var outdoorPlants: [Plant] {
        controller.plants.filter { $0.type == .outdoor }
    }
    
    var body: some View {
        NavigationStack {
            List {
                if !indoorPlants.isEmpty {
                    Section(header: Text("Indoor")) {
                        ForEach(indoorPlants) { plant in
                            NavigationLink(destination: DetailView(plantID: plant.id, controller: controller)) {
                                CardView(plant: plant)
                            }
                        }
                        .onDelete { indexSet in
                            indexSet.forEach { index in
                                let plant = indoorPlants[index]
                                controller.delete(plant)
                            }
                        }
                    }
                }
                
                if !outdoorPlants.isEmpty {
                    Section(header: Text("Outdoor")) {
                        ForEach(outdoorPlants) { plant in
                            NavigationLink(destination: DetailView(plantID: plant.id, controller: controller)) {
                                CardView(plant: plant)
                            }
                        }
                        .onDelete { indexSet in
                            indexSet.forEach { index in
                                let plant = outdoorPlants[index]
                                controller.delete(plant)
                            }
                        }
                    }
                }
                
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle("Ryu's Nursery")
            .scrollContentBackground(.hidden)
            .background(
                Image("backgroundImage")
                    .edgesIgnoringSafeArea(.all)
                    .overlay(Color.white.opacity(0.7))
            )
            .navigationBarItems(trailing: NavigationLink("+", destination: InsertView(controller: controller)))
            .onAppear {
                controller.loadData()
            }
        }
    }
}
