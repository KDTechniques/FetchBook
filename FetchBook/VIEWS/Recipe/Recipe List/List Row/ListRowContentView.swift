//
//  ListRowContentView.swift
//  FetchBook
//
//  Created by Mr. Kavinda Dilshan on 2024-10-06.
//

import SwiftUI

struct ListRowContentView: View {
    // MARK: - PROPERTIES
    let recipe: RecipeModel
    
    // MARK: - PRIVATE PROPERTIES
    @State private var showVideoPlayer: Bool = false
    
    // MARK: - INITIALIZER
    init(recipe: RecipeModel) {
        self.recipe = recipe
    }
    
    // MARK: - BODY
    var body: some View {
        let videoID: String? = Helpers.extractYouTubeVideoID(from: recipe.secureYoutubeURLString ?? "")
        
        NavigationLink {
            RecipeBlogPostView(secureBlogPostURLString: recipe.secureBlogPostURLString)
                .overlay { FloatingYTPlayerView(showVideoPlayer: $showVideoPlayer, videoID: videoID) }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        BlogPostVideoPlayerButtonView(showVideoPlayer: $showVideoPlayer, videoID: videoID)
                    }
                }
                .navigationTitle("Blog Post")
                .navigationBarTitleDisplayMode(.inline)
        } label: {
            ListRowView(recipe: recipe)
        }
        .listRowBackground(Color.clear)
        .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 0))
    }
}

// MARK: - PREVIEWS
#Preview("ListRowContentView") {
    ListRowContentView(recipe: .mockObject)
}
