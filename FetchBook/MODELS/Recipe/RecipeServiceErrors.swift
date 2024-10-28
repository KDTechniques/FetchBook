//
//  RecipeServiceErrors.swift
//  FetchBook
//
//  Created by Mr. Kavinda Dilshan on 2024-10-21.
//

import Foundation

/// Enum representing the various errors that can occur in the RecipeService.
enum RecipeServiceErrors: Error, LocalizedError {
    /// The provided URL is invalid.
    case invalidURL(String)
    
    /// An error occurred during the network request.
    case networkError(Error)
    
    /// An error occurred while decoding the data.
    case decodingError(Error)
    
    /// The specified file was not found.
    case fileNotFound(String)
    
    /// A localized message describing what error occurred.
    var errorDescription: String? {
        switch self {
        case .invalidURL(let urlString):
            return "The URL `\(urlString)` is invalid."
            
        case .networkError(let error):
            return "Network error occurred: \(error.localizedDescription)"
            
        case .decodingError(let error):
            return "Failed to decode the data: \(error.localizedDescription)"
            
        case .fileNotFound(let fileName):
            return "The file `\(fileName)` was not found."
        }
    }
}
