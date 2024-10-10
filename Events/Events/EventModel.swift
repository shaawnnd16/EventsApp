//
//  ContentView.swift
//  Events
//
//  Created by Shawn De Alwis on 10/10/2024.
//

import Foundation
import CoreData

// CoreData Model for Events
struct Event: Identifiable {
    var id: UUID
    var title: String
    var date: Date
    var location: String
    var favorited: Bool
}

// Eventbrite API Response Structure
struct EventResponse: Codable {
    var events: [EventDetail]
}

struct EventDetail: Codable, Identifiable {
    var id: String
    var name: EventName
    var start: EventTime
    var venue: Venue

    struct EventName: Codable {
        var text: String
    }

    struct EventTime: Codable {
        var local: String
    }

    struct Venue: Codable {
        var address: VenueAddress
        var latitude: String
        var longitude: String

        struct VenueAddress: Codable {
            var localized_address_display: String
        }
    }
}

