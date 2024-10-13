//
//  FavoritesManager.swift
//  Events
//
//  Created by Shawn De Alwis on 13/10/2024.
//

import Foundation

class FavoritesManager: ObservableObject {
    @Published var favoriteEvents: [Event] = []

    func addFavorite(event: Event) {
        if !favoriteEvents.contains(where: { $0.id == event.id }) {
            favoriteEvents.append(event)
        }
    }

    func removeFavorite(event: Event) {
        favoriteEvents.removeAll { $0.id == event.id }
    }

    func isFavorite(event: Event) -> Bool {
        return favoriteEvents.contains(where: { $0.id == event.id })
    }
}



