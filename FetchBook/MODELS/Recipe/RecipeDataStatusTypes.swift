//
//  RecipeDataStatusTypes.swift
//  FetchBook
//
//  Created by Mr. Kavinda Dilshan on 2024-10-07.
//

import Foundation

/// Enum representing the various states of recipe data validity.
enum RecipeDataStatusTypes: String, CaseIterable {
    /// Indicates a default state or successful state.
    case none
    
    /// Indicates that a network request is currently in progress.
    case fetching
    
    /// Indicates that the data is malformed and cannot be decoded.
    case malformed
    
    /// Indicates that the JSON data is empty.
    case emptyData
    
    /// Indicates that no search results were found.
    case emptyResult
}
