//
//  ContentView.swift
//  Events
//
//  Created by Shawn De Alwis on 10/10/2024.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var events: [Event] = []
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -33.8688, longitude: 151.2093), // Sydney Coordinates
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    
    // Store the venue annotations
    @State private var selectedEvent: Event? = nil
    @State private var venueAnnotations: [VenueAnnotation] = []

    var body: some View {
        NavigationView {
            VStack {
                // Map with venue annotations
                Map(coordinateRegion: $region, annotationItems: venueAnnotations) { venue in
                    MapAnnotation(coordinate: venue.coordinate) {
                        VStack {
                            // Show a pin that is tappable
                            Image(systemName: "mappin.circle.fill")
                                .foregroundColor(.blue)
                                .font(.title)

                            // When a pin is clicked, show a pop-up with event name
                            if venue.event == selectedEvent {
                                VStack {
                                    Text(venue.title)
                                        .font(.caption)
                                        .bold()
                                        .padding(5)
                                        .background(Color.white)
                                        .cornerRadius(8)
                                        .shadow(radius: 10)
                                }
                                .onTapGesture {
                                    // Navigate to detailed view when the pop-up is clicked
                                    selectedEvent = nil // Clear the selected event
                                    // Navigate to the event detail page
                                    navigateToEventDetail(event: venue.event)
                                }
                            }
                        }
                        .onTapGesture {
                            // Set the selected event when pin is tapped
                            selectedEvent = venue.event
                        }
                    }
                }
                .frame(height: 300)
                
                // Event list
                List(events) { event in
                    NavigationLink(destination: EventDetailView(event: event)) {
                        EventRow(event: event)
                    }
                }
            }
            .navigationTitle("Local Events")
            .onAppear {
                fetchTicketmasterEvents()
            }
        }
    }

    // Fetch events from Ticketmaster API and update the map with venue pins
    func fetchTicketmasterEvents() {
        let apiKey = "vdtrwPsB3CcHMkljDjdrzhPwN3UvvN20"
        let urlString = "https://app.ticketmaster.com/discovery/v2/events.json?apikey=\(apiKey)&city=Sydney&classificationName=music"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            // Debugging: Print the raw response data
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Response JSON: \(jsonString)")
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(TicketmasterResponse.self, from: data)
                DispatchQueue.main.async {
                    self.events = response._embedded.events
                    self.venueAnnotations = response._embedded.events.compactMap { event in
                        // Make sure the event has valid latitude and longitude
                        if let latitude = Double(event._embedded.venues.first?.location.latitude ?? ""),
                           let longitude = Double(event._embedded.venues.first?.location.longitude ?? "") {
                            return VenueAnnotation(
                                title: event.name,
                                coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                                event: event // Store the full event object for navigation
                            )
                        }
                        return nil
                    }
                }
            } catch {
                print("Failed to decode JSON: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    // Function to handle navigation to the detailed event view
    func navigateToEventDetail(event: Event) {
        // This is where you would navigate to the event detail screen programmatically
        // For now, the NavigationLink in the list is handling the navigation
    }
}







