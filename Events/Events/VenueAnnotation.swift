//
//  VenueAnnotation.swift
//  Events
//
//  Created by Shawn De Alwis on 10/10/2024.
//

import MapKit

struct VenueAnnotation: Identifiable {
    let id = UUID()
    let title: String
    let coordinate: CLLocationCoordinate2D
    let event: Event // Reference to the full event object
}


