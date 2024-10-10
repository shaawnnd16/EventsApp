//
//  ErrorHandling.swift
//  Events
//
//  Created by Shawn De Alwis on 10/10/2024.
//

import Foundation
import SwiftUI

enum AppError: Error {
    case networkError(String)
    case dataParsingError(String)
    case locationError(String)

    var errorMessage: String {
        switch self {
        case .networkError(let message):
            return "Network Error: \(message)"
        case .dataParsingError(let message):
            return "Data Parsing Error: \(message)"
        case .locationError(let message):
            return "Location Error: \(message)"
        }
    }
}

struct ErrorView: View {
    var error: AppError

    var body: some View {
        VStack {
            Text(error.errorMessage)
                .foregroundColor(.red)
                .font(.headline)
        }
    }
}

