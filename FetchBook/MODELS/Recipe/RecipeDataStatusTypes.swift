//
//  RecipeDataStatusTypes.swift
//  FetchBook
//
//  Created by Mr. Kavinda Dilshan on 2024-10-07.
//

import Foundation

enum RecipeDataStatusTypes: String, CaseIterable {
    /// Indicates a default state or successful state.
    case none
    case fetching
    case malformed
    case emptyData
    
    /// Indicates that no search results were found.
    case emptyResult
}
