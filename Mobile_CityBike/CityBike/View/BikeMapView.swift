//
//  CityBikeMapView.swift
//  CityBike
//
//  Created by admin on 2025-03-12.
//

import SwiftUI
import MapKit

struct BikeMapView: View {
    @StateObject var netController = APIController()
    @State private var selectedNet: DataField? = nil
    
    // Toronto
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 43.6532, longitude: -79.3832),
        span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
    )
    
    var body: some View {
        NavigationView {
            ZStack {
                // Annotations on the map
                Map(coordinateRegion: $region, annotationItems: netController.nets) { net in
                    MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: net.location.latitude, longitude: net.location.longitude)) {
                        Button(action: {
                            selectedNet = net
                        }) {
                            
                            Image(systemName: "bicycle")
                                .foregroundColor(.blue)
                                .padding(6)
                                .background(Color.white)
                                .clipShape(Circle())
                        }
                    }
                }
                
                // Card view at the bottom
                if let net = selectedNet {
                    VStack {
                        Spacer()
                        NavigationLink(destination: BikeDetailView(net: net)) {
                            HStack {
                                Image(systemName: "bicycle.circle")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .padding()
                                VStack(alignment: .leading) {
                                    Text(net.name)
                                        .font(.headline)
                                    Text(net.location.city)
                                        .font(.subheadline)
                                    Text(net.location.country)
                                        .font(.caption)
                                }
                                Spacer()
                            }
                            .padding()
                            .background(Color.white.opacity(0.65))
                            .padding()
                        }
                    }
                }
            }
            .onAppear {
                netController.fetch()
            }
        }
    }
}
