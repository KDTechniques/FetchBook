//
//  RecipeImagePreviewContextMenuItemsView.swift
//  FetchBook
//
//  Created by Mr. Kavinda Dilshan on 2024-10-18.
//

import SwiftUI

struct RecipeImagePreviewContextMenuItemsView: View {
    // MARK: - PROPERTIES
    @Binding var blogPostItem: [BlogPostItemModel]
    let blogPostURLString: String?
    let youtubeURLString: String?
    
    // MARK: -  INITIALIZER
    init(blogPostItem: Binding<[BlogPostItemModel]>, blogPostURLString: String?, youtubeURLString: String?) {
        _blogPostItem = blogPostItem
        self.blogPostURLString = blogPostURLString
        self.youtubeURLString = youtubeURLString
    }
    
    // MARK: - BODY
    var body: some View {
        Group {
            Button { appendBlogPostItem(false) } label: { Label("Go to Blog Post", systemImage: "book") }
            Button { appendBlogPostItem(true) } label: { Label("Watch on YouTube", systemImage: "play.circle") }
        }
    }
}

// MARK: - PREVIEWS
#Preview("RecipeImagePreviewContextMenuItemsView") {
    RecipeImagePreviewContextMenuItemsView(blogPostItem: .constant([]), blogPostURLString: "", youtubeURLString: "")
}

// MARK: - EXTENSIONS
extension RecipeImagePreviewContextMenuItemsView {
    // MARK: - FUNCTIONS
    
    // MARK: - appendBlogPostItem
    private func appendBlogPostItem(_ showVideoPlayer: Bool) {
        let item: BlogPostItemModel = .init(
            secureBlogPostURLString: blogPostURLString,
            secureYoutubeURLString: youtubeURLString,
            showVideoPlayer: showVideoPlayer
        )
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { blogPostItem.append(item) }
    }
}
