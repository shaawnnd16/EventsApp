//
//  MapViewScreen.swift
//  Events
//
//  Created by Shawn De Alwis on 13/10/2024.
//

import SwiftUI
import MapKit

struct MapViewScreen: View {
    @State private var events: [Event] = []
    @State private var filteredEvents: [Event] = []
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -33.8688, longitude: 151.2093), // Sydney Coordinates
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    
    @State private var selectedEvent: Event? = nil
    @State private var venueAnnotations: [VenueAnnotation] = []
    @State private var showEventDetail = false
    
    // Filter options
    @State private var selectedCategory: String = "All"
    @State private var filterOptions: [String] = ["All", "Music", "Sports", "Theater", "Comedy", "Arts", "Other"]
    @State private var selectedDateFilter: String = "All"
    @State private var dateFilterOptions: [String] = ["All", "Upcoming", "Past"]
    
    // Modal control
    @State private var showFilterSheet = false

    var body: some View {
        NavigationView {
            VStack {
                // Map with annotations
                Map(coordinateRegion: $region, annotationItems: venueAnnotations) { venue in
                    MapAnnotation(coordinate: venue.coordinate) {
                        VStack {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundColor(.blue)
                                .font(.title)

                            // Display event info popup when selected
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
                                    selectedEvent = nil
                                    showEventDetail = true // Trigger navigation to detail view
                                }
                            }
                        }
                        .onTapGesture {
                            // Set selected event when pin is tapped
                            selectedEvent = venue.event
                        }
                    }
                }
                .frame(height: 300)

                // List of filtered events
                List(filteredEvents) { event in
                    NavigationLink(destination: EventDetailView(event: event)) {
                        EventRow(event: event)
                    }
                }
            }
            .navigationTitle("Map & Events")
            .navigationBarItems(trailing: Button(action: {
                showFilterSheet = true // Show filter modal
            }) {
                Image(systemName: "line.horizontal.3.decrease.circle")
                    .font(.title)
            })
            .onAppear {
                // Only fetch events if they haven't been loaded before
                if events.isEmpty {
                    fetchTicketmasterEvents() // Fetch events when the view appears only if they haven't been loaded
                }
            }
            .sheet(isPresented: $showFilterSheet) {
                // Filter Modal View
                FilterView(
                    selectedCategory: $selectedCategory,
                    selectedDateFilter: $selectedDateFilter,
                    filterOptions: filterOptions,
                    dateFilterOptions: dateFilterOptions,
                    onApplyFilters: {
                        applyFilters() // Apply filters when "Apply" is pressed
                        showFilterSheet = false // Dismiss the modal
                    }
                )
            }
            .background(
                NavigationLink(
                    destination: selectedEvent.map { EventDetailView(event: $0) },
                    isActive: $showEventDetail
                ) {
                    EmptyView()
                }
                .hidden()
            )
        }
    }

    // Function to fetch events from the Ticketmaster API
    private func fetchTicketmasterEvents() {
        let apiKey = "vdtrwPsB3CcHMkljDjdrzhPwN3UvvN20" // Replace with your actual Ticketmaster API key
        let urlString = "https://app.ticketmaster.com/discovery/v2/events.json?apikey=\(apiKey)&city=Sydney"
        
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

            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(TicketmasterResponse.self, from: data)
                DispatchQueue.main.async {
                    self.events = response._embedded!.events
                    
                    // Apply filters after fetching events
                    self.applyFilters()
                }
            } catch {
                print("Failed to decode JSON: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }

    // Apply multiple filters to the list of events and map annotations
    private func applyFilters() {
        filteredEvents = events
        venueAnnotations = []

        // Filter by category using the correct field, e.g., classifications.segment.name
        if selectedCategory != "All" {
            filteredEvents = filteredEvents.filter { event in
                if let segmentName = event.classifications?.first?.segment.name {
                    let categoryName = mapSegmentToCategory(segmentName: segmentName)
                    return categoryName.lowercased() == selectedCategory.lowercased()
                }
                return selectedCategory == "Other" // If no category, place in 'Other'
            }
        }

        // Filter by date (Upcoming/Past)
        if selectedDateFilter != "All" {
            filteredEvents = filteredEvents.filter { event in
                let isUpcoming = self.isUpcoming(eventDate: event.dates.start.localDate)
                return selectedDateFilter == "Upcoming" ? isUpcoming : !isUpcoming
            }
        }

        // Update map annotations based on filtered events
        venueAnnotations = filteredEvents.compactMap { event in
            if let latitude = Double(event._embedded.venues.first?.location.latitude ?? ""),
               let longitude = Double(event._embedded.venues.first?.location.longitude ?? "") {
                return VenueAnnotation(
                    title: event.name,
                    coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                    event: event
                )
            }
            return nil
        }
    }

    // Helper function to check if an event is upcoming
    private func isUpcoming(eventDate: String) -> Bool {
        guard let eventDate = dateFormatter.date(from: eventDate) else { return false }
        return eventDate > Date()
    }

    // DateFormatter for parsing event dates
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    // Map segment names to categories
    private func mapSegmentToCategory(segmentName: String) -> String {
        switch segmentName.lowercased() {
        case "music": return "Music"
        case "sports": return "Sports"
        case "theater": return "Theater"
        case "comedy": return "Comedy"
        case "arts", "art": return "Arts"
        default: return "Other"
        }
    }
}






