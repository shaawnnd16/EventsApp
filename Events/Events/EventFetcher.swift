//
//  EventFetcher.swift
//  Events
//
//  Created by Shawn De Alwis on 10/10/2024.
//

import Foundation

class EventFetcher: ObservableObject {
    @Published var events = [EventDetail]()

    func fetchEvents() {
        guard let url = URL(string: "https://www.eventbriteapi.com/v3/events/search/?location.latitude=YOUR_LAT&location.longitude=YOUR_LONG&token=YOUR_API_TOKEN") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    print("Network error: \(error.localizedDescription)")
                }
                return
            }
            
            if let data = data {
                do {
                    let eventResponse = try JSONDecoder().decode(EventResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.events = eventResponse.events
                    }
                } catch {
                    DispatchQueue.main.async {
                        print("JSON parsing error: \(error.localizedDescription)")
                    }
                }
            }
        }.resume()
    }
}

