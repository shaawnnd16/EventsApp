//
//  FavoritesView.swift
//  Events
//
//  Created by Shawn De Alwis on 13/10/2024.
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var favorites: FavoritesManager // Use the shared favorites manager

    var body: some View {
        NavigationView {
            if favorites.favoriteEvents.isEmpty {
                Text("No favorite events yet!")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List(favorites.favoriteEvents) { event in
                    NavigationLink(destination: EventDetailView(event: event)) {
                        Text(event.name)
                    }
                }
                .navigationTitle("Favorites")
            }
        }
    }
}





