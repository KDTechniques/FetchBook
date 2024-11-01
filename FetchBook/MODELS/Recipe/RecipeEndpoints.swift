//
//  RecipeEndpoints.swift
//  FetchBook
//
//  Created by Mr. Kavinda Dilshan on 2024-10-07.
//

import Foundation

// NOTE: DEBUG PURPOSES ONLY

/// Enum representing the types of recipe endpoints, each with a raw string value.
enum RecipeEndpointTypes: String, CaseIterable {
    case all = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
    case malformed = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json"
    case empty = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json"
    
    var typeString: String {
        switch self {
        case .all:
            return "all"
        case .malformed:
            return "malformed"
        case .empty:
            return "empty"
        }
    }
    
    var urlString: String {
        self.rawValue
    }
    
    /// return a `RecipeEndpointModel` for the endpoint type.
    var endpointModel: RecipeEndpointModel {
        return RecipeEndpointModel(type: self, urlString: self.urlString)
    }
}

/// Model representing a recipe API endpoint.
/// Contains the endpoint type and its corresponding URL.
struct RecipeEndpointModel: Hashable {
    let type: RecipeEndpointTypes
    let urlString: String
}
