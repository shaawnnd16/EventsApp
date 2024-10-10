//
//  MapView.swift
//  Events
//
//  Created by Shawn De Alwis on 10/10/2024.
//

import SwiftUI
import MapKit

struct MapView: View {
    @ObservedObject var locationManager = LocationManager()
    @ObservedObject var eventFetcher = EventFetcher()
    
    var body: some View {
        Map(coordinateRegion: $locationManager.region, annotationItems: eventFetcher.events) { event in
            MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: Double(event.venue.latitude) ?? 0.0, longitude: Double(event.venue.longitude) ?? 0.0)) {
                VStack {
                    Image(systemName: "pin.circle.fill")
                        .foregroundColor(.red)
                    Text(event.name.text)
                }
            }
        }
        .onAppear {
            eventFetcher.fetchEvents()
        }
    }
}

