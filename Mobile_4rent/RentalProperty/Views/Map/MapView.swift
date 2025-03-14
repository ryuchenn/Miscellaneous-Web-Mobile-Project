//
//  MapView.swift
//  RentalProperty
//
//  Created by admin on 2025-03-07.
//

import SwiftUI
import MapKit
import CoreLocation

struct MapView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var propertyController: PropertyController
    @EnvironmentObject var accountController: AccountController
    @EnvironmentObject var favoriteController: FavoriteController
    @StateObject private var locationHelper = LocationHelper()
    
    @State var properties = [Property]()
    @State private var position: MapCameraPosition = .region(MKCoordinateRegion(
        center: DefaultCenter,
        span: DefaultSpan
    ))
    @State private var selectedProperty: Property?
    @State private var firstLoad: Bool = false
    
    var navigateProperty: Property?
    
    func handleOnClickMarker(_ marker: Property) {
        if let latitude = marker.latitude, let longitude = marker.longitude, latitude != 0, longitude != 0 {
            selectedProperty = marker
            withAnimation(.easeInOut(duration: 0.6)) {
                position = .region(MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                    span: DefaultSpan
                ))
            }
        }
    }
    
    func getCenterCoordinate(for coordinates: [CLLocationCoordinate2D]) -> CLLocationCoordinate2D? {
        guard !coordinates.isEmpty else { return nil }

        var minLat = coordinates.first!.latitude
        var maxLat = coordinates.first!.latitude
        var minLng = coordinates.first!.longitude
        var maxLng = coordinates.first!.longitude

        for coordinate in coordinates {
            let lat = coordinate.latitude
            let lng = coordinate.longitude

            minLat = min(minLat, lat)
            maxLat = max(maxLat, lat)
            minLng = min(minLng, lng)
            maxLng = max(maxLng, lng)
        }

        let centerLat = (minLat + maxLat) / 2
        let centerLng = (minLng + maxLng) / 2

        return CLLocationCoordinate2D(latitude: centerLat, longitude: centerLng)
    }
    
    func moveMapCenter(_ latitude: Double, _ longitude: Double) {
        withAnimation(.easeInOut(duration: 0.6)) {
            position = .region(MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: latitude,
                    longitude: longitude
                ),
                span: DefaultSpan
            ))
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    Map(position: $position) {
                        ForEach(propertyController.properties.filter({ navigateProperty != nil ? navigateProperty?.id == $0.id : true }), id: \.id) { p in
                            if let latitude = p.latitude, let longitude = p.longitude, latitude != 0, longitude != 0 {
                                Annotation("", coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude)) {
                                    Button(action: {
                                        handleOnClickMarker(p)
                                    }) {
                                        let backgroundColor = selectedProperty?.id == p.id ? Color("OrangeColor") : Color("TealBlueColor")
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 6)
                                                .fill(backgroundColor)
                                                .frame(width: 28, height: 28)
                                            
                                            Image(systemName: "house.fill")
                                                .font(.system(size: 12))
                                                .foregroundColor(.white)
                                                .frame(width: 16, height: 16)
                                                .padding(6)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .simultaneousGesture(
                        TapGesture().onEnded {
                            if navigateProperty == nil {
                                selectedProperty = nil
                            }
                        }
                    )
                    .onAppear {
                        if let selected = navigateProperty {
                            handleOnClickMarker(selected)
                        }
                    }
                    
                    Button(action: {
                        locationHelper.checkLocationAuthorization()
                    }) {
                        Image(systemName: "location.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                    }
                    .frame(width: 36, height: 36)
                    .background(Color("OrangeColor"))
                    .cornerRadius(8)
                    .position(x: UIScreen.main.bounds.width - 50, y: UIScreen.main.bounds.height - 195)
                    .padding()
                    .buttonStyle(.plain)
                    
                    if navigateProperty != nil {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                        }
                        .frame(width: 46, height: 46)
                        .background(Color.black.opacity(0.8))
                        .cornerRadius(25)
                        .position(x: 30, y: 10)
                        .padding()
                        .buttonStyle(.plain)
                    }
                    
                    if selectedProperty != nil {
                        ZStack {
                            VStack {
                                NavigationLink(
                                    destination: PropertyDetailView(property: selectedProperty!)
                                        .environmentObject(accountController)
                                        .environmentObject(propertyController)
                                        .environmentObject(favoriteController)
                                ) {
                                    HStack {
                                        ZStack {
                                            PropertyPhoto(
                                                property: selectedProperty!,
                                                height: 158,
                                                cornerRadius: 0
                                            )
                                            PropertyBadgeView(property: selectedProperty!)
                                        }
                                        
                                        VStack {
                                            PropertyDetail(property: selectedProperty!)
                                        }
                                        .padding(.vertical, 15)
                                    }
                                    .frame(maxHeight: 158)
                                }
                            }
//                            .frame(maxWidth: 520)
                            .background(.white)
                            .cornerRadius(6)
                            .shadow(
                                color: Color.black.opacity(0.2),
                                radius: 5,
                                x: 0,
                                y: 2
                            )
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                        .padding(15)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
            .navigationTitle("Map")
            .navigationBarHidden(true)
            .onChange(of: locationHelper.lastUpdatedTime) {
                if let lat = locationHelper.lastKnownLocation?.latitude, let long = locationHelper.lastKnownLocation?.longitude {
                    moveMapCenter(lat, long)
                }
            }
            .onAppear {
                var latitude = DefaultCenter.latitude
                var longitude = DefaultCenter.longitude
                
                if navigateProperty != nil {
                    if let lat = navigateProperty?.latitude, let long = navigateProperty?.longitude {
                        latitude = lat
                        longitude = long
                    }
                    moveMapCenter(latitude, longitude)
                } else {
                    let coordinates = propertyController.properties.compactMap { p -> CLLocationCoordinate2D? in
                        if let lat = p.latitude, let long = p.longitude {
                            return CLLocationCoordinate2D(latitude: lat, longitude: long)
                        } else {
                            return nil
                        }
                    }
                    
                    if let centerCoordinate = getCenterCoordinate(for: coordinates) {
                        moveMapCenter(centerCoordinate.latitude, centerCoordinate.longitude)
                    }
                }
                
                propertyController.all() { result in
                    switch result {
                        case .success(let properties):
                            if let properties = properties {
                                self.properties = properties
                            }
                        case .failure(let error):
                            print("Failed to load properties: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}


#Preview {    
    MapView().environmentObject(PropertyController.getInstance())
}
