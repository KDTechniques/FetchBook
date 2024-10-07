//
//  RecipeEndpoints.swift
//  FetchBook
//
//  Created by Mr. Kavinda Dilshan on 2024-10-07.
//

import Foundation

// DEBUG PURPOSES ONLY

/// Enum representing the types of recipe endpoints, each with a raw string value.
/// This enum is also `CaseIterable`, allowing iteration over all cases.
enum RecipeEndpointTypes: String, CaseIterable { case all, malformed, empty }

/// Enumeration representing different API endpoints for fetching recipes.
/// Each case is a static constant containing a `RecipeEndpointModel`,
/// which defines the type of endpoint and the corresponding URL.
enum RecipeEndpoints: CaseIterable, Hashable {
    // Endpoint for all recipes.
    static let all: RecipeEndpointModel = .init(type: .all, urlString: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")
    
    // Endpoint for malformed data.
    static let malformed: RecipeEndpointModel = .init(type: .malformed, urlString: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json")
    
    // Endpoint for empty data.
    static let empty: RecipeEndpointModel = .init(type: .empty, urlString: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json")
    
    // An array of all available recipe endpoint models, used for iterating or selection in UI elements.
    static var allCases: [RecipeEndpointModel] {
        [all, malformed, empty]
    }
}

/// Model representing a recipe API endpoint.
/// Contains the endpoint type and its corresponding URL.
struct RecipeEndpointModel: Hashable {
    let type: RecipeEndpointTypes
    let urlString: String
}
