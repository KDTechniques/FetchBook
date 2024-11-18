//
//  RecipeBlogPostView.swift
//  FetchBook
//
//  Created by Mr. Kavinda Dilshan on 2024-10-06.
//

import SwiftUI

struct RecipeBlogPostView: View {
    // MARK: - INITIAL PROPERTIES
    let secureBlogPostURLString: String?
    let secureYoutubeURLString: String?
    @State private var showVideoPlayer: Bool
    
    // MARK: - INITIALAIZER
    init(secureBlogPostURLString: String?, secureYoutubeURLString: String?, showVideoPlayer: Bool = false) {
        self.secureBlogPostURLString = secureBlogPostURLString
        self.secureYoutubeURLString = secureYoutubeURLString
        self.showVideoPlayer = showVideoPlayer
    }
    
    // MARK: - PRIVATE PROPERTIES
    @State private var progress: Double = .zero
    
    // MARK: - BODY
    var body: some View {
        let videoID: String? = Helpers.extractYouTubeVideoID(from: secureYoutubeURLString ?? "")
        Group {
            if let urlString: String = secureBlogPostURLString,
               let url: URL = .init(string: urlString) {
                VStack(spacing: 0) {
                    BlogPostHProgressView(progress: progress)
                    WebView(url: url, progress: $progress)
                }
            } else {
                CustomContentNotAvailableView(ContentNotAvailableValues.recipeBlogPost)
            }
        }
        .overlay {
            FloatingYTPlayerView(showVideoPlayer: $showVideoPlayer, videoID: videoID)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                BlogPostVideoPlayerButtonView(showVideoPlayer: $showVideoPlayer, videoID: videoID)
            }
        }
        .navigationTitle("Blog Post")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - PREVIEWS
#Preview("RecipeBlogPostView") {
    let mockObject: RecipeModel = RecipeModel.mockObject
    RecipeBlogPostView(
        secureBlogPostURLString: mockObject.secureBlogPostURLString,
        secureYoutubeURLString: mockObject.secureYoutubeURLString
    )
}
