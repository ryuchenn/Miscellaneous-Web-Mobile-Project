//
//  MapView.swift
//  ChiaHung_Plants
//
//  Created by admin on 2025-03-05.
//

import SwiftUI
import CoreLocation
import MapKit

struct AnnotatedItem: Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
}

struct MapView: View {
    @Binding var coordinate: CLLocationCoordinate2D?
    @Environment(\.presentationMode) var presentationMode
    
    // Default Location: Toronto (latitude: 43.6532, longitude: -79.3832)
    @State private var region: MKCoordinateRegion = MKCoordinateRegion(
         center: CLLocationCoordinate2D(latitude: 43.6532, longitude: -79.3832),
         span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    var body: some View {
        VStack {
            Map(coordinateRegion: $region, annotationItems: [AnnotatedItem(coordinate: region.center)]) { item in
                MapPin(coordinate: item.coordinate)
            }
            .edgesIgnoringSafeArea(.all)
            
            Button("Done") {
                coordinate = region.center
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
        }
    }
}
