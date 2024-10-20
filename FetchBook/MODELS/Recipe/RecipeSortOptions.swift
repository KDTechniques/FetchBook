//
//  RecipeSortOptions.swift
//  FetchBook
//
//  Created by Mr. Kavinda Dilshan on 2024-10-20.
//

import Foundation

/// Enumeration representing the sorting options available for recipes.
///
/// This enum provides different ways to sort a collection of recipes, which can be used to organize
/// recipes alphabetically or leave them unsorted. It also conforms to `CaseIterable` to easily
/// generate a list of all cases and to `Identifiable` for use in SwiftUI lists or UI components.
enum RecipeSortOptions: String, CaseIterable, Identifiable {
    /// The unique identifier for each sorting option, using the raw string value.
    var id: String { self.rawValue }
    
    /// Sort recipes alphabetically from A to Z.
    case ascending = "Ascending"
    
    /// Sort recipes alphabetically from Z to A.
    case descending = "Descending"
    
    /// No sorting applied, default state.
    case none = "Default"
}
