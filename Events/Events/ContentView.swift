//
//  ContentView.swift
//  Events
//
//  Created by Shawn De Alwis on 10/10/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var events: [Event] = []
    @State private var loading = false
    @State private var errorMessage: String? = nil
    
    private let eventService = EventService()

    var body: some View {
        NavigationView {
            VStack {
                if loading {
                    ProgressView("Loading events...")
                        .padding()
                } else if let errorMessage = errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                } else if events.isEmpty {
                    Text("No events found for this month.")
                        .font(.headline)
                        .padding()
                } else {
                    // Title for the section
                    Text("Happening This Month")
                        .font(.title2)
                        .bold()
                        .padding(.top, 20)
                    
                    // Vertically scrolling list of events displayed as bars (only showing 5 events)
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 20) { // Adjust spacing for more or less space between bars
                            ForEach(events.prefix(5)) { event in // Limit to 5 events
                                NavigationLink(destination: EventDetailView(event: event)) {
                                    VStack(alignment: .leading) {
                                        // Display the event image if available
                                        if let url = URL(string: event.imageUrl) {
                                            AsyncImage(url: url) { image in
                                                image
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(height: 180)
                                                    .cornerRadius(10)
                                            } placeholder: {
                                                Color.gray.opacity(0.5)
                                                    .frame(height: 180)
                                                    .cornerRadius(10)
                                            }
                                        } else {
                                            // Placeholder in case URL is not valid
                                            Color.gray.opacity(0.5)
                                                .frame(height: 180)
                                                .cornerRadius(10)
                                        }

                                        // Event name
                                        Text(event.name)
                                            .font(.headline)
                                            .padding(.top, 8)
                                            .lineLimit(2)
                                            .frame(maxWidth: .infinity, alignment: .leading)

                                        // Event date and time
                                        Text(event.eventDate)
                                            .font(.footnote)
                                            .foregroundColor(.secondary)
                                        
                                        // Venue information
                                        Text(event.venueInfo)
                                            .font(.footnote)
                                            .foregroundColor(.secondary)
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .shadow(radius: 5)
                                    .padding(.horizontal)
                                }
                            }
                        }
                    }
                }
                Spacer()
            }
            .navigationTitle("Sydney Events")
            .onAppear {
                loadEventsThisMonth()
            }
        }
    }
    
    // Fetch events happening this month
    private func loadEventsThisMonth() {
        loading = true
        eventService.fetchEventsThisMonth { result in
            DispatchQueue.main.async {
                self.loading = false
                switch result {
                case .success(let events):
                    self.events = events
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}























