//
//  RecipeTextsView.swift
//  FetchBook
//
//  Created by Mr. Kavinda Dilshan on 2024-10-06.
//

import SwiftUI

struct RecipeTextsView: View {
    // MARK: INITIAL PROPERTIES
    let name: String
    let cuisine: String
    
    // MARK: - INITIALIZER
    init(name: String, cuisine: String) {
        self.name = name
        self.cuisine = cuisine
    }
    
    // MARK: - BODY
    var body: some View {
        VStack(alignment: .leading) {
            Text(name)
            
            Text(cuisine)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - PREVIEWS
#Preview("RecipeTextsView") {
    let mockObject: RecipeModel = .mockObject
    RecipeTextsView(name: mockObject.name, cuisine: mockObject.cuisine)
}
