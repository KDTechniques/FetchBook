//
//  RecipeServiceErrors.swift
//  FetchBook
//
//  Created by Mr. Kavinda Dilshan on 2024-10-21.
//

import Foundation

enum RecipeServiceErrors: Error, LocalizedError {
    case invalidURL(String)
    case networkError(Error)
    case decodingError(Error)
    case fileNotFound(String)
    
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
