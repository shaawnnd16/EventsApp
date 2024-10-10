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

struct Event: Identifiable, Decodable {
    let id: String
    let name: String
    let dates: EventDates
    let _embedded: EventVenues
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
}

struct City: Decodable {
    let name: String
}




