//
//  ListRowContentView.swift
//  FetchBook
//
//  Created by Mr. Kavinda Dilshan on 2024-10-06.
//

import SwiftUI
import SDWebImageSwiftUI

struct ListRowContentView: View {
    // MARK: - INITIAL PROPERTIES
    let recipe: RecipeModel
    let firstItemID: String
    let lastItemID: String
    
    // MARK: - INITIALIZER
    init(recipe: RecipeModel, firstItemID: String, lastItemID: String) {
        self.recipe = recipe
        self.firstItemID = firstItemID
        self.lastItemID = lastItemID
    }
    
    // MARK: - BODY
    var body: some View {
        NavigationLink {
            RecipeBlogPostView(
                secureBlogPostURLString: recipe.secureBlogPostURLString,
                secureYoutubeURLString: recipe.secureYoutubeURLString
            )
        } label: {
            ListRowView(recipe: recipe)
        }
        .listRowSeparator(firstItemID == recipe.id ? .hidden : .visible, edges: .top)
        .listRowSeparator(lastItemID == recipe.id ? .hidden : .visible, edges: .bottom)
    }
}

// MARK: - PREVIEWS
#Preview("ListRowContentView") {
    ListRowContentView(recipe: .mockObject, firstItemID: "", lastItemID: "")
}
