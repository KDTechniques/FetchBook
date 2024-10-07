//
//  RecipeBlogPostView.swift
//  FetchBook
//
//  Created by Mr. Kavinda Dilshan on 2024-10-06.
//

import SwiftUI

struct RecipeBlogPostView: View {
    // MARK: - PROPERTIES
    let secureBlogPostURLString: String?
    
    // MARK: - PRIVATE PROPERTIES
    @State private var progress: Double = .zero
    
    // MARK: - INITIALAIZER
    init(secureBlogPostURLString: String?) {
        self.secureBlogPostURLString = secureBlogPostURLString
    }
    
    // MARK: - BODY
    var body: some View {
        if let urlString: String = secureBlogPostURLString,
           let url: URL = .init(string: urlString) {
            VStack(spacing: 0) {
                BlogPostHProgressView(progress: progress)
                WebView(url: url, progress: $progress)
            }
        } else {
            CustomContentNotAvailableView(
                .init(
                    systemImageName: "book",
                    title: "No Recipe Insights",
                    description: "The blog post related to this recipe is currently unavailable. Please check back later or explore other recipes."
                )
            )
        }
    }
}

// MARK: - PREVIEWS
#Preview("RecipeBlogPostView") {
    RecipeBlogPostView(secureBlogPostURLString: RecipeModel.mockObject.secureBlogPostURLString)
}
