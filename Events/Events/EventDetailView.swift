//
//  EventFetcher.swift
//  Events
//
//  Created by Shawn De Alwis on 10/10/2024.
//

import SwiftUI
import MapKit

struct EventDetailView: View {
    var event: Event

    @EnvironmentObject var favorites: FavoritesManager
    @State private var showMapDirections = false
    @State private var mapItem: MKMapItem?
    @State private var showShareSheet = false // State for showing the share sheet

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                // Hero Image placeholder
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .clipped()
                    .overlay(
                        VStack {
                            Spacer()
                            HStack {
                                Text(event.name)
                                    .font(.largeTitle)
                                    .bold()
                                    .foregroundColor(.white)
                                    .shadow(radius: 5)
                                    .padding()
                                Spacer()
                            }
                        }
                    )

                // Event Information
                VStack(alignment: .leading, spacing: 10) {
                    Text("Date: \(event.dates.start.localDate)")
                        .font(.headline)
                        .padding(.top, 10)

                    if let venueName = event._embedded.venues.first?.name {
                        Text("Location: \(venueName)")
                            .font(.subheadline)
                    } else {
                        Text("Location: Not Available")
                            .font(.subheadline)
                    }

                    // Map showing event location
                    if let latitudeString = event._embedded.venues.first?.location.latitude,
                       let longitudeString = event._embedded.venues.first?.location.longitude,
                       let latitude = Double(latitudeString),
                       let longitude = Double(longitudeString) {

                        // Interactive MapView showing event location
                        MapView(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
                            .frame(height: 200)
                            .cornerRadius(10)
                            .padding(.vertical, 10)

                        // Directions Button
                        Button(action: {
                            openMaps(latitude: latitude, longitude: longitude, venueName: event._embedded.venues.first?.name)
                        }) {
                            HStack {
                                Image(systemName: "location.fill")
                                Text("Get Directions")
                                    .fontWeight(.bold)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                        }
                    } else {
                        // Show message if no map or location data available
                        Text("Map and directions not available")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(.vertical, 10)
                    }

                    // Event Description Placeholder
                    Text("Event Description")
                        .font(.headline)
                        .padding(.top, 10)
                    Text(event.description ?? "This is a placeholder for the event description. Replace with real data.")
                        .font(.body)
                        .foregroundColor(.secondary)

                    // Get Tickets Button
                    if let ticketURLString = event.url, let ticketURL = URL(string: ticketURLString) {
                        Button(action: {
                            openTicketmasterPage(url: ticketURL)
                        }) {
                            HStack {
                                Image(systemName: "ticket.fill")
                                Text("Get Tickets")
                                    .fontWeight(.bold)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                        }
                    } else {
                        Text("No tickets available")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(.vertical, 10)
                    }
                }
                .padding()

                // Action Bar with Share and Favorite buttons
                HStack(spacing: 20) {
                    // Favorite Button
                    Button(action: {
                        if favorites.isFavorite(event: event) {
                            favorites.removeFavorite(event: event)
                        } else {
                            favorites.addFavorite(event: event)
                        }
                    }) {
                        Image(systemName: favorites.isFavorite(event: event) ? "heart.fill" : "heart")
                            .font(.title)
                            .padding()
                            .background(favorites.isFavorite(event: event) ? Color.red.opacity(0.8) : Color.gray.opacity(0.2))
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }

                    // Share Button
                    Button(action: {
                        showShareSheet.toggle() // Trigger share sheet
                    }) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.title)
                            .padding()
                            .background(Color.blue.opacity(0.8))
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                }
                .padding()

                Spacer()
            }
        }
        .navigationTitle("Event Details")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(activityItems: ["Check out this event: \(event.name) on \(event.dates.start.localDate)"])
        }
    }

    // Function to handle opening maps for directions
    private func openMaps(latitude: Double, longitude: Double, venueName: String?) {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = venueName
        mapItem.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ])
    }

    // Function to open the Ticketmaster page for the event
    private func openTicketmasterPage(url: URL) {
        UIApplication.shared.open(url)
    }
}





















