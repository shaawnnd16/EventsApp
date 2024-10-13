//
//  LocationAnnotation.swift
//  Events
//
//  Created by Shawn De Alwis on 13/10/2024.
//

import Foundation
import MapKit

// Struct to represent a location annotation (pin on the map)
struct LocationAnnotation: Identifiable {
    let id = UUID() // Unique identifier for each annotation
    let coordinate: CLLocationCoordinate2D // The coordinate to place the annotation on the map
}

