//
//  FirestoreManager.swift
//  Events
//
//  Created by Shawn De Alwis on 14/10/2024.
//

import FirebaseFirestore

class FirestoreManager: ObservableObject {
    private var db = Firestore.firestore()

    // Save a favorited event to Firestore
    func saveFavorite(event: Event) {
        let eventData = [
            "id": event.id,
            "name": event.name,
            "date": event.dates.start.localDate,
            "venue": event.venueInfo
        ]
        db.collection("favorites").document(event.id).setData(eventData) { error in
            if let error = error {
                print("Error saving event: \(error.localizedDescription)")
            } else {
                print("Event successfully saved to Firestore")
            }
        }
    }

    // Remove a favorited event from Firestore
    func removeFavorite(event: Event) {
        db.collection("favorites").document(event.id).delete() { error in
            if let error = error {
                print("Error removing event: \(error.localizedDescription)")
            } else {
                print("Event successfully removed from Firestore")
            }
        }
    }

    // Fetch favorited events from Firestore
    func fetchFavorites(completion: @escaping ([Event]) -> Void) {
        db.collection("favorites").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching events: \(error)")
                return
            }

            let events = snapshot?.documents.compactMap { doc -> Event? in
                let data = doc.data()
                guard let id = data["id"] as? String,
                      let name = data["name"] as? String,
                      let date = data["date"] as? String,
                      let venue = data["venue"] as? String else {
                    return nil
                }

                return Event(
                    id: id,
                    name: name,
                    dates: EventDates(
                        start: EventStart(localDate: date, localTime: nil),
                        additionalDates: nil
                    ),
                    _embedded: EventVenues(venues: [Venue(name: venue, city: City(name: ""), location: Location(latitude: "", longitude: ""))]),
                    classifications: nil,
                    description: nil,
                    promoter: nil,
                    url: nil,
                    images: nil
                )
            }
            completion(events ?? [])
        }
    }
}





