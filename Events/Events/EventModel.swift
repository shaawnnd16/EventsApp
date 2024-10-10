//
//  MapView.swift
//  Events
//
//  Created by Shawn De Alwis on 10/10/2024.
//

import Foundation

struct TicketmasterResponse: Decodable {
    let _embedded: EmbeddedEvents
}

struct EmbeddedEvents: Decodable {
    let events: [Event]
}

// Make Event conform to Equatable
struct Event: Identifiable, Decodable, Equatable {
    let id: String
    let name: String
    let dates: EventDates
    let _embedded: EventVenues
    
    static func ==(lhs: Event, rhs: Event) -> Bool {
        return lhs.id == rhs.id // Compare events based on their unique ID
    }
}

struct EventDates: Decodable {
    let start: EventStart
}

struct EventStart: Decodable {
    let localDate: String
    let localTime: String?
}

struct EventVenues: Decodable {
    let venues: [Venue]
}

struct Venue: Decodable {
    let name: String
    let city: City
    let location: Location
}

struct City: Decodable {
    let name: String
}

struct Location: Decodable {
    let latitude: String
    let longitude: String
}





