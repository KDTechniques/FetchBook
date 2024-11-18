//
//  RecipeImagePreviewContextMenuItemsView.swift
//  FetchBook
//
//  Created by Mr. Kavinda Dilshan on 2024-10-18.
//

import SwiftUI

struct RecipeImagePreviewContextMenuItemsView: View {
    // MARK: - INITIAL PROPERTIES
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
            blogPostButton
            youtubeButton
        }
    }
}

// MARK: - PREVIEWS
#Preview("RecipeImagePreviewContextMenuItemsView") {
    RecipeImagePreviewContextMenuItemsView(blogPostItem: .constant([]), blogPostURLString: "", youtubeURLString: "")
}

// MARK: - EXTENSIONS
extension RecipeImagePreviewContextMenuItemsView {
    //  MARK: - blogPostButton
    private var blogPostButton: some View {
        Button {
            appendBlogPostItem(false)
        } label: {
            Label("Go to Blog Post", systemImage: "book")
        }
    }
    
    // MARK: - youtubeButton
    private var youtubeButton: some View {
        Button {
            appendBlogPostItem(true)
        } label: {
            Label("Watch on YouTube", systemImage: "play.circle")
        }
    }
    
    // MARK: - FUNCTIONS
    
    // MARK: - appendBlogPostItem
    private func appendBlogPostItem(_ showVideoPlayer: Bool) {
        let item: BlogPostItemModel = .init(
            secureBlogPostURLString: blogPostURLString,
            secureYoutubeURLString: youtubeURLString,
            showVideoPlayer: showVideoPlayer
        )
        Task {
            try? await Task.sleep(nanoseconds: 200_000_000)
            blogPostItem.append(item)
        }
    }
}
