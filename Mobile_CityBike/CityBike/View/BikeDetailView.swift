//
//  CityBikeDetailView.swift
//  CityBike
//
//  Created by admin on 2025-03-12.
//
import SwiftUI
import MapKit

struct BikeDetailView: View {
    let net: DataField
    @State private var alertMessage: String = ""
    @State private var showAlert: Bool = false
    @State private var isFavorite: Bool = false
    let firebase = DBController()
    
    
    var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: net.location.latitude, longitude: net.location.longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.white]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 20) {
                    Map(coordinateRegion: .constant(region), annotationItems: [net]) { item in
                        MapMarker(
                            coordinate: CLLocationCoordinate2D(
                                latitude: item.location.latitude,
                                longitude: item.location.longitude
                            ),
                            tint: .red
                        )
                    }
                    .frame(height: 300)
                    .cornerRadius(15)
                    .shadow(radius: 5)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(alignment: .top) {
                            Image(systemName: "flag.fill")
                                .foregroundColor(.green)
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Country:")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                Text(net.location.country)
                                    .font(.title2)
                                    .fontWeight(.semibold)
                            }
                        }
                        
                        HStack(alignment: .top) {
                            Image(systemName: "mappin.and.ellipse")
                                .foregroundColor(.blue)
                            VStack(alignment: .leading, spacing: 4) {
                                Text("City:")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text(net.location.city)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        HStack(alignment: .top) {
                            Image(systemName: "briefcase.fill")
                                .foregroundColor(.orange)
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Companies")
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                                Text(net.company.joined(separator: ", "))
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(radius: 5)
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    
                    Spacer()
                }
                .padding()
            }
        }
        .navigationTitle(net.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    if !isFavorite {
                        firebase.add(net: net) { err in
                            if err == nil {
                                isFavorite = true
                                alertMessage = "Location added to favorites."
                                showAlert = true
                            } else {
                                print("Error: \(err?.localizedDescription ?? "")")
                            }
                        }
                    } else {
                        firebase.delete(net: net) { err in
                            if err == nil {
                                isFavorite = false
                                alertMessage = "Location removed from favorites."
                                showAlert = true
                            } else {
                                print("Error: \(err?.localizedDescription ?? "")")
                            }
                        }
                    }
                }) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(isFavorite ? .red : .blue)
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Favorite"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
        .onAppear {
            checkFavorite()
        }
    }
    
    func checkFavorite() {
        firebase.fetch { nets, err in
            if let nets = nets, nets.contains(where: { $0.id == net.id }) {
                isFavorite = true
            } else {
                isFavorite = false
            }
        }
    }
}

