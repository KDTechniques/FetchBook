//
//  RecipeEndpoints.swift
//  FetchBook
//
//  Created by Mr. Kavinda Dilshan on 2024-10-07.
//

import Foundation

// NOTE: DEBUG PURPOSES ONLY
enum RecipeEndpointTypes: String, CaseIterable {
    case all
    case malformed
    case empty
    
    var urlString: String {
        switch self {
        case .all:
            return "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
        case .malformed:
            return "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json"
        case .empty:
            return "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json"
        }
    }
}
