//
//  EventFetcher.swift
//  Events
//
//  Created by Shawn De Alwis on 10/10/2024.
//

import SwiftUI

struct EventDetailView: View {
    var event: Event

    var body: some View {
        VStack(alignment: .leading) {
            Text(event.name)
                .font(.largeTitle)
                .bold()
            Text(event._embedded.venues.first?.name ?? "Unknown Venue")
                .font(.title2)
                .padding(.top, 2)
            if let localTime = event.dates.start.localTime {
                Text("\(event.dates.start.localDate) at \(localTime)")
                    .font(.title3)
                    .padding(.top, 5)
            } else {
                Text(event.dates.start.localDate)
                    .font(.title3)
                    .padding(.top, 5)
            }
            Spacer()
        }
        .padding()
        .navigationTitle("Event Details")
    }
}





