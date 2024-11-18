//
//  RecipeSortTypes.swift
//  FetchBook
//
//  Created by Mr. Kavinda Dilshan on 2024-10-20.
//

import Foundation

enum RecipeSortTypes: String, CaseIterable, Identifiable {
    var id: String {
        return self.rawValue
    }
    
    case ascending = "Ascending"
    case descending = "Descending"
    case none = "Default"
}
