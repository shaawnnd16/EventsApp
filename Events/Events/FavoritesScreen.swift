//
//  FavoritesScreen.swift
//  Events
//
//  Created by Shawn De Alwis on 13/10/2024.
//

import SwiftUI

struct FavoritesScreen: View {
    @State private var favoritedEvents: [Event] = [] // This will be populated with saved events
    @State private var filterOption: String = "All" // Default filter
    @State private var showFilterOptions = false // State for showing filter options
    
    // Sample filter options
    let filterOptions = ["All", "Upcoming", "Past", "Music", "Sports", "Networking"]

    var body: some View {
        NavigationView {
            VStack {
                // Filter bar
                HStack {
                    Button(action: {
                        showFilterOptions.toggle() // Toggle filter options
                    }) {
                        Text("Filter: \(filterOption)")
                            .padding(8)
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(8)
                    }
                    Spacer()
                }
                .padding()

                // List of favorited events
                if favoritedEvents.isEmpty {
                    Text("No favorited events.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(favoritedEvents) { event in
                        HStack {
                            // Sample image for event (you would replace this with a real image if available)
                            Image(systemName: "star.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .padding()

                            VStack(alignment: .leading) {
                                Text(event.name)
                                    .font(.headline)
                                if let localTime = event.dates.start.localTime {
                                    Text("\(event.dates.start.localDate) at \(localTime)")
                                        .font(.subheadline)
                                } else {
                                    Text(event.dates.start.localDate)
                                        .font(.subheadline)
                                }

                                // Event countdown
                                if let countdownText = countdownToEvent(event.dates.start.localDate) {
                                    Text(countdownText)
                                        .font(.footnote)
                                        .foregroundColor(.green)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Favorites")
            .onAppear {
                // Load saved/favorited events
                loadFavoritedEvents()
            }
            .actionSheet(isPresented: $showFilterOptions) {
                ActionSheet(
                    title: Text("Filter Events"),
                    buttons: filterOptions.map { option in
                        .default(Text(option)) {
                            filterOption = option
                            filterFavoritedEvents()
                        }
                    } + [.cancel()]
                )
            }
        }
    }

    // Function to load saved/favorited events
    private func loadFavoritedEvents() {
        // Sample data; replace with actual saved events loading logic
        favoritedEvents = [
//            Event(id: "1", name: "Music Festival", dates: EventDates(start: EventStart(localDate: "2024-11-20", localTime: "18:00")), _embedded: EventVenues(venues: []), classifications: [Classification(segment: Segment(name: "Music"))]),
//            Event(id: "2", name: "Networking Event", dates: EventDates(start: EventStart(localDate: "2024-10-22", localTime: "12:00")), _embedded: EventVenues(venues: []), classifications: [Classification(segment: Segment(name: "Networking"))]),
//            Event(id: "3", name: "Sports Championship", dates: EventDates(start: EventStart(localDate: "2024-10-25", localTime: "15:00")), _embedded: EventVenues(venues: []), classifications: [Classification(segment: Segment(name: "Sports"))])
        ]
    }

    // Function to filter saved events based on the selected filter option
    private func filterFavoritedEvents() {
        switch filterOption {
        case "Upcoming":
            favoritedEvents = favoritedEvents.filter { isUpcoming(eventDate: $0.dates.start.localDate) }
        case "Past":
            favoritedEvents = favoritedEvents.filter { !isUpcoming(eventDate: $0.dates.start.localDate) }
        case "Music", "Sports", "Networking":
            favoritedEvents = favoritedEvents.filter { event in
                event.classifications?.first?.segment.name == filterOption
            }
        default:
            loadFavoritedEvents() // Load all events for "All"
        }
    }

    // Helper function to check if an event is upcoming
    private func isUpcoming(eventDate: String) -> Bool {
        guard let eventDate = dateFormatter.date(from: eventDate) else { return false }
        return eventDate > Date()
    }

    // Countdown to event date
    private func countdownToEvent(_ eventDate: String) -> String? {
        guard let eventDate = dateFormatter.date(from: eventDate) else { return nil }
        let daysLeft = Calendar.current.dateComponents([.day], from: Date(), to: eventDate).day ?? 0
        return daysLeft > 0 ? "\(daysLeft) days left" : "Today"
    }
    
    // DateFormatter for parsing event dates
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}

