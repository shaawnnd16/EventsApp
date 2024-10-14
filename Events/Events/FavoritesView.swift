//
//  FavoritesView.swift
//  Events
//
//  Created by Shawn De Alwis on 13/10/2024.
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var favorites: FavoritesManager
    @State private var favoritedEvents: [Event] = []

    var body: some View {
        NavigationView {
            List(favoritedEvents) { event in
                VStack(alignment: .leading) {
                    Text(event.name)
                        .font(.headline)
                    Text(event.dates.start.localDate)
                        .font(.subheadline)
                    Text(event.venueInfo)
                        .font(.subheadline)
                }
            }
            .navigationTitle("Favorite Events")
            .onAppear {
                // Load favorites from Firestore
                favorites.loadFavorites()
                favoritedEvents = favorites.favoriteEvents
            }
        }
    }
}








