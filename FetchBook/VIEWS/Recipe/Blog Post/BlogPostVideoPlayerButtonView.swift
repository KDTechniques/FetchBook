//
//  BlogPostVideoPlayerButtonView.swift
//  FetchBook
//
//  Created by Mr. Kavinda Dilshan on 2024-10-06.
//

import SwiftUI

struct BlogPostVideoPlayerButtonView: View {
    // MARK: - INITIAL PROPERTIES
    @Binding var showVideoPlayer:  Bool
    let videoID: String?
    
    // MARK: - INITIALIZER
    init(showVideoPlayer: Binding<Bool>, videoID: String?) {
        _showVideoPlayer = showVideoPlayer
        self.videoID = videoID
    }
    
    // MARK: - BODY
    var body: some View {
        Button {
            showVideoPlayer = true
        } label: {
            Image(systemName: SystemImageAssetsValues.youtubePlayButton)
        }
        .disabled(videoID == nil)
        .onDisappear { showVideoPlayer = false }
    }
}

// MARK: - PREVIEWS
#Preview("BlogPostVideoPlayerButtonView") {
    BlogPostVideoPlayerButtonView(
        showVideoPlayer: .constant(false),
        videoID: Helpers.extractYouTubeVideoID(from: RecipeModel.mockObject.secureBlogPostURLString ?? "")
    )
}
