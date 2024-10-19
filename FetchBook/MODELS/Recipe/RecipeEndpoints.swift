//
//  RecipeEndpoints.swift
//  FetchBook
//
//  Created by Mr. Kavinda Dilshan on 2024-10-07.
//

import Foundation

// DEBUG PURPOSES ONLY

// Enum representing the types of recipe endpoints, each with a raw string value.
enum RecipeEndpointTypes: String, CaseIterable {
    case all = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
    case malformed = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json"
    case empty = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json"
    
    // Computed property to return the type as a string.
    var typeString: String {
        switch self {
        case .all: "all"
        case .malformed: "malformed"
        case .empty: "empty"
        }
    }
    
    // Computed property to return the corresponding URL string.
    var urlString: String { self.rawValue }
    
    // Computed property to return a RecipeEndpointModel for the type.
    var endpointModel: RecipeEndpointModel { RecipeEndpointModel(type: self, urlString: self.urlString) }
}

// Model representing a recipe API endpoint.
// Contains the endpoint type and its corresponding URL.
struct RecipeEndpointModel: Hashable {
    let type: RecipeEndpointTypes
    let urlString: String
}
