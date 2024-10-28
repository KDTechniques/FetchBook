//
//  RecipeSortTypes.swift
//  FetchBook
//
//  Created by Mr. Kavinda Dilshan on 2024-10-20.
//

import Foundation

/// Enumeration representing the sorting options available for recipes.
enum RecipeSortTypes: String, CaseIterable, Identifiable {
    /// The unique identifier for each sorting option, using the raw string value.
    var id: String {
        return self.rawValue
    }
    
    /// Sort recipes alphabetically from A to Z.
    case ascending = "Ascending"
    
    /// Sort recipes alphabetically from Z to A.
    case descending = "Descending"
    
    /// No sorting applied, default state.
    case none = "Default"
}
