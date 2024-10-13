//
//  MapView.swift
//  Events
//
//  Created by Shawn De Alwis on 13/10/2024.
//

import SwiftUI
import MapKit

// Custom MapView for showing a location snippet with interaction enabled
struct MapView: View {
    var coordinate: CLLocationCoordinate2D

    // Create a @State property for region
    @State private var region: MKCoordinateRegion

    // Initialize the @State region with a default value
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        _region = State(initialValue: MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        ))
    }

    var body: some View {
        Map(coordinateRegion: $region, annotationItems: [LocationAnnotation(coordinate: coordinate)]) { location in
            MapMarker(coordinate: location.coordinate, tint: .red)
        }
        .frame(height: 200)
        .cornerRadius(8)
        .padding(.vertical, 10)
    }
}

//// Struct to represent a location annotation (pin on the map)
//struct LocationAnnotation: Identifiable {
//    let id = UUID() // Unique identifier for each annotation
//    let coordinate: CLLocationCoordinate2D // The coordinate to place the annotation on the map
//}







