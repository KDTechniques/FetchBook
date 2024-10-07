//
//  ListRowView.swift
//  FetchBook
//
//  Created by Mr. Kavinda Dilshan on 2024-10-06.
//

import SwiftUI

struct ListRowView: View {
    // MARK: - PROPERTIES
    let recipe: RecipeModel
    
    // MARK: - INITIALIZER
    init(recipe: RecipeModel) {
        self.recipe = recipe
    }
    
    // MARK: - BODY
    var body: some View {
        HStack(alignment: .top) {
            RecipeImageView(
                thumbnailImageURLString: recipe.secureThumbnailURLString,
                largeImageURLString: recipe.securePhotoURLLargeString
            )
            
            RecipeTextsView(name: recipe.name, cuisine: recipe.cuisine)
                .padding(.top, 10)
        }
    }
}

// MARK: - PREVIEWS
#Preview("ListRowView") {
    ListRowView(recipe: .mockObject)
}
