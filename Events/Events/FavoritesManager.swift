//
//  FavoritesManager.swift
//  Events
//
//  Created by Shawn De Alwis on 13/10/2024.
//

import Foundation
import FirebaseFirestore

class FavoritesManager: ObservableObject {
    @Published var favoriteEvents: [Event] = []
    private var firestoreManager = FirestoreManager()

    // Add a favorite and save to Firestore
    func addFavorite(event: Event) {
        if !favoriteEvents.contains(where: { $0.id == event.id }) {
            favoriteEvents.append(event)
            firestoreManager.saveFavorite(event: event)
        }
    }

    // Remove a favorite from the list and Firestore
    func removeFavorite(event: Event) {
        favoriteEvents.removeAll(where: { $0.id == event.id })
        firestoreManager.removeFavorite(event: event)
    }

    // Check if an event is a favorite
    func isFavorite(event: Event) -> Bool {
        return favoriteEvents.contains(where: { $0.id == event.id })
    }

    // Load favorited events from Firestore
    func loadFavorites() {
        firestoreManager.fetchFavorites { events in
            DispatchQueue.main.async {
                self.favoriteEvents = events
            }
        }
    }
}






