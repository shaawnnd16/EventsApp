//
//  EventsApp.swift
//  Events
//
//  Created by Shawn De Alwis on 10/10/2024.
//

import SwiftUI

@main
struct NeighborhoodEventsTrackerApp: App {
    // StateObject to manage shared FavoritesManager across views
    @StateObject private var favorites = FavoritesManager()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(favorites) // Pass the shared favorites manager to all views
        }
    }
}





