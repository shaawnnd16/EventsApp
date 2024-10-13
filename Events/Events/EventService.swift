//
//  EventService.swift
//  Events
//
//  Created by Shawn De Alwis on 13/10/2024.
//

import Foundation

class EventService {
    private let apiKey = "vdtrwPsB3CcHMkljDjdrzhPwN3UvvN20" // Replace with your actual Ticketmaster API key
    
    // Function to fetch events happening this month in Sydney
    func fetchEventsThisMonth(completion: @escaping (Result<[Event], Error>) -> Void) {
        let dateFormatter = ISO8601DateFormatter()
        let startDate = Date() // Today's date
        
        // Get the last date of the current month
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = 1
        dateComponents.day = -1
        let endDate = calendar.date(byAdding: dateComponents, to: startDate)!
        
        let startDateString = dateFormatter.string(from: startDate)
        let endDateString = dateFormatter.string(from: endDate)
        
        let urlString = "https://app.ticketmaster.com/discovery/v2/events.json?apikey=\(apiKey)&city=Sydney&startDateTime=\(startDateString)&endDateTime=\(endDateString)&locale=*"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 500, userInfo: nil)))
                return
            }
            
            do {
                // Print the raw JSON response for debugging
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Raw JSON response: \(jsonString)")
                }

                let ticketmasterResponse = try JSONDecoder().decode(TicketmasterResponse.self, from: data)
                
                // Check if the _embedded key exists, otherwise return an empty array
                if let embedded = ticketmasterResponse._embedded {
                    completion(.success(embedded.events))
                } else {
                    print("No events found in response")
                    completion(.success([])) // Return an empty array if no events are found
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}








