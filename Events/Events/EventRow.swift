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
            // Use an icon based on the event type (e.g., Music, Sports, Theater, Other)
            let iconName = getIconForCategory(event) // Function to determine the icon based on category
            Image(systemName: iconName)
                .resizable()
                .frame(width: 40, height: 40)
                .padding(.trailing, 10)

            VStack(alignment: .leading) {
                Text(event.name)
                    .font(.headline)
                    .foregroundColor(.primary) // Main text color
                Text(event._embedded.venues.first?.name ?? "Unknown Venue")
                    .font(.subheadline)
                    .foregroundColor(.secondary) // Secondary text color
                
                if let localTime = event.dates.start.localTime {
                    Text("\(event.dates.start.localDate) at \(localTime)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                } else {
                    Text(event.dates.start.localDate)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 5) // Add some vertical padding for spacing
    }
    
    // Function to return the correct icon based on event classification
    func getIconForCategory(_ event: Event) -> String {
        if let segmentName = event.classifications?.first?.segment.name {
            switch segmentName.lowercased() {
            case "music":
                return "music.note"
            case "sports":
                return "sportscourt"
            case "theater":
                return "theatermasks"
            case "comedy":
                return "face.smiling"
            case "arts":
                return "paintbrush"
            default:
                return "theatermasks" // Use theater masks for "Other"
            }
        }
        return "theatermasks" // Fallback icon for "Other"
    }
}








