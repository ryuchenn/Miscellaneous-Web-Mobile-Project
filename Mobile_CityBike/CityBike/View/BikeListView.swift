//
//  CityBikeListView.swift
//  CityBike
//
//  Created by admin on 2025-03-12.
//

import SwiftUI

/// (HOME View) List retrieved from the API
struct BikeListView: View {
    @StateObject var netController = APIController()
    @State private var searchText: String = ""
    
    var filteredNets: [DataField] {
        if searchText.isEmpty {
            return netController.nets
        } else {
            return netController.nets.filter { $0.location.city.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        NavigationView {
            List(filteredNets) { net in
                NavigationLink(destination: BikeDetailView(net: net)) {
                    Text(net.location.city)
                }
            }
            .navigationTitle("City Bikes")
            .searchable(text: $searchText, prompt: "Search city")
            .onAppear {
                netController.fetch()
            }
        }
    }
}
