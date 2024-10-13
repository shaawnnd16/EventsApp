//
//  MapView.swift
//  Events
//
//  Created by Shawn De Alwis on 10/10/2024.
//

import Foundation

// Response model for Ticketmaster API
struct TicketmasterResponse: Decodable {
    let _embedded: EmbeddedEvents? // Embedded events, can be optional
}

// Embedded events structure
struct EmbeddedEvents: Decodable {
    let events: [Event] // List of events
}

// Event model which conforms to Identifiable, Decodable, and Equatable
struct Event: Identifiable, Decodable, Equatable {
    let id: String
    let name: String
    let dates: EventDates
    let _embedded: EventVenues
    let classifications: [Classification]? // Optional classifications
    let description: String? // Optional description
    let promoter: Promoter? // Optional promoter information
    let url: String? // Optional event URL
    let images: [EventImage]? // Optional list of event images
    
    // Computed property to get the first available image URL, with a default placeholder
    var imageUrl: String {
        return images?.first?.url ?? "https://via.placeholder.com/150" // Return placeholder if no images available
    }

    // Computed property to get formatted event date and time
    var eventDate: String {
        // Format the event date and time
        let date = dates.start.localDate
        if let time = dates.start.localTime {
            return "\(formatDate(date)) at \(formatTime(time))"
        }
        return formatDate(date)
    }
    
    // Computed property to get the venue name and city, with default values if missing
    var venueInfo: String {
        if let venue = _embedded.venues.first {
            return "\(venue.name), \(venue.city.name)"
        }
        return "Unknown Venue, Unknown City"
    }
    
    // Computed property to get latitude and longitude (if available)
    var eventLocation: String {
        if let venue = _embedded.venues.first,
           let latitude = venue.location.latitude,
           let longitude = venue.location.longitude {
            return "Latitude: \(latitude), Longitude: \(longitude)"
        }
        return "Location not available"
    }

    // Helper method to format the date in a readable format
    private func formatDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: dateString) else { return dateString }
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    // Helper method to format the time in a readable format
    private func formatTime(_ timeString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        guard let time = formatter.date(from: timeString) else { return timeString }
        formatter.timeStyle = .short
        return formatter.string(from: time)
    }
    
    // Equatable conformance to compare events by their ID
    static func ==(lhs: Event, rhs: Event) -> Bool {
        return lhs.id == rhs.id
    }
}

// Event Image model to hold the image URL
struct EventImage: Decodable {
    let url: String
}

// Event classification model, representing event categories or segments
struct Classification: Decodable {
    let segment: Segment
}

// Segment for event categories (e.g., Music, Sports)
struct Segment: Decodable {
    let name: String // Category name (e.g., Music, Sports)
}

// Event date-related models
struct EventDates: Decodable {
    let start: EventStart
    let additionalDates: [String]? // Optional additional dates for the event
}

// Start date and time for the event
struct EventStart: Decodable {
    let localDate: String
    let localTime: String? // Optional local time
}

// Event venues data (embedded)
struct EventVenues: Decodable {
    let venues: [Venue]
}

// Venue details, including name, city, and location
struct Venue: Decodable {
    let name: String
    let city: City
    let location: Location
}

// City details, including name
struct City: Decodable {
    let name: String
}

// Location details for a venue, including latitude and longitude
struct Location: Decodable {
    let latitude: String?
    let longitude: String?
}

// Promoter (Organizer) details
struct Promoter: Decodable {
    let name: String? // Optional promoter name
    let description: String? // Optional description of the promoter
}

// Model for representing a general category (e.g., Music, Sports) in the app UI
struct Category: Identifiable {
    var id: String
    var name: String
    var icon: String // Icon name for display purposes
}











