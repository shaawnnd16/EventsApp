//
//  EventsApp.swift
//  Events
//
//  Created by Shawn De Alwis on 10/10/2024.
//

import SwiftUI
import Firebase

@main
struct NeighborhoodEventsTrackerApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(FavoritesManager())  // Provide FavoritesManager here
        }
    }
}








