//
//  LocationManager.swift
//  Events
//
//  Created by Shawn De Alwis on 10/10/2024.
//

import SwiftUI

struct EventRow: View {
    var event: Event

    var body: some View {
        HStack {
            // Add an SF Symbol as an icon
            Image(systemName: "customIcon") // You can use different icons here based on event type
                .resizable()
                .frame(width: 40, height: 40)
                .padding()

            VStack(alignment: .leading) {
                Text(event.name)
                    .font(.headline)
                Text(event._embedded.venues.first?.name ?? "Unknown Venue")
                    .font(.subheadline)
                if let localTime = event.dates.start.localTime {
                    Text("\(event.dates.start.localDate) at \(localTime)")
                        .font(.subheadline)
                } else {
                    Text("\(event.dates.start.localDate)")
                        .font(.subheadline)
                }
            }
        }
    }
}





