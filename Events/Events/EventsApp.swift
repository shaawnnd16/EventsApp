//
//  EventsApp.swift
//  Events
//
//  Created by Shawn De Alwis on 10/10/2024.
//

import SwiftUI

@main
struct EventsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            EventListView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

