//
//  FilterView.swift
//  Events
//
//  Created by Shawn De Alwis on 13/10/2024.
//

import SwiftUI

struct FilterView: View {
    @Binding var selectedCategory: String
    @Binding var selectedDateFilter: String
    let filterOptions: [String]
    let dateFilterOptions: [String]
    let onApplyFilters: () -> Void

    var body: some View {
        NavigationView {
            Form {
                // Category Filter
                Section(header: Text("Category")) {
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(filterOptions, id: \.self) { category in
                            Text(category).tag(category)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                }

                // Date Filter
                Section(header: Text("Date")) {
                    Picker("Date", selection: $selectedDateFilter) {
                        ForEach(dateFilterOptions, id: \.self) { dateFilter in
                            Text(dateFilter).tag(dateFilter)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                }
            }
            .navigationTitle("Filters")
            .navigationBarItems(trailing: Button("Apply") {
                onApplyFilters()
            })
        }
    }
}

