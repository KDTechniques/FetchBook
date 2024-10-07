//
//  RecipeDataStatusTypes.swift
//  FetchBook
//
//  Created by Mr. Kavinda Dilshan on 2024-10-07.
//

import Foundation

/// Enum representing the various states of recipes data validity.
enum RecipeDataStatusTypes: String {
    case none
    case fetching
    case malformed
    case emptyData
    case emptyResult
}
