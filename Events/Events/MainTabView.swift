//
//  MainTabView.swift
//  Events
//
//  Created by Shawn De Alwis on 13/10/2024.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }

            MapViewScreen()
                .tabItem {
                    Image(systemName: "map.fill")
                    Text("Map")
                }
            
            FavoritesView() // New Favorites Tab
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Favorites")
                }
        }
    }
}


