//
//  FloatingYTPlayerView.swift
//  FetchBook
//
//  Created by Mr. Kavinda Dilshan on 2024-10-06.
//

import SwiftUI

struct FloatingYTPlayerView: View {
    // MARK: - PROPERTIES
    @Binding var showVideoPlayer: Bool
    let videoID: String?
    
    // MARK: - INITIALIZER
    init(showVideoPlayer: Binding<Bool>, videoID: String?) {
        _showVideoPlayer = showVideoPlayer
        self.videoID = videoID
    }
    
    // MARK: - BODY
    var body: some View {
        if let videoID: String = videoID, showVideoPlayer {
            DraggableYouTubePlayerView(videoID: videoID) {
                showVideoPlayer = false
            }
            .onDisappear {
                showVideoPlayer = false
            }
        }
    }
}

// MARK: - PREVIEWS
#Preview("FloatingYTPlayerView") {
    FloatingYTPlayerView(
        showVideoPlayer: .constant(false),
        videoID: Helpers.extractYouTubeVideoID(from: RecipeModel.mockObject.secureBlogPostURLString ?? "")
    )
}
