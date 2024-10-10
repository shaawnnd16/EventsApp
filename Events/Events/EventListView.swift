//
//  EventListView.swift
//  Events
//
//  Created by Shawn De Alwis on 10/10/2024.
//

import SwiftUI

struct EventListView: View {
    @ObservedObject var eventFetcher = EventFetcher()

    var body: some View {
        NavigationView {
            List(eventFetcher.events) { event in
                VStack(alignment: .leading) {
                    Text(event.name.text)
                        .font(.headline)
                    Text(event.start.local)
                        .font(.subheadline)
                    Text(event.venue.address.localized_address_display)
                        .font(.subheadline)
                }
            }
            .onAppear {
                eventFetcher.fetchEvents()
            }
            .navigationTitle("Local Events")
        }
    }
}

