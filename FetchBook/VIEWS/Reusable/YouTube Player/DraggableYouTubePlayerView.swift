//
//  DraggableYouTubePlayerView.swift
//  FetchBook
//
//  Created by Mr. Kavinda Dilshan on 2024-10-05.
//

import SwiftUI

struct DraggableYouTubePlayerView: View {
    // MARK: - PROPERTIES
    let videoID: String
    let action: () -> ()
    
    // MARK: - PRIVATE PROPERTIES
    @State private var currentOffset = CGSize.zero
    @State private var lastOffset = CGSize.zero
    @State private var isDragging: Bool = false
    @State private var isLoading: Bool = true
    
    let screenWidth = UIScreen.main.bounds.width - 50
    let screenHeight = UIScreen.main.bounds.height - 80
    let rectWidth: CGFloat = UIScreen.main.bounds.size.width - 150
    private var rectHeight: CGFloat { rectWidth/16*9 } // 16:9 YT video player frame ratio
    
    
    // MARK: INITIALIZER
    init(videoID: String, action: @escaping () -> ()) {
        self.videoID = videoID
        self.action = action
    }
    
    // MARK: - BODY
    var body: some View {
        YouTubePlayerView(videoID: videoID, isLoading: $isLoading)
            .overlay { YTPlaceholderView(showPlaceholder: isLoading) }
            .clipShape(.rect(cornerRadius: 10))
            .overlay(alignment: .topTrailing) { YTPlayerTopTrailingButtonView(isDragging: isDragging) { action() } }
            .frame(width: rectWidth, height: rectHeight)
            .offset(x: currentOffset.width + lastOffset.width, y: currentOffset.height + lastOffset.height)
            .gesture(DragGesture().onChanged { dragOnChange($0) }.onEnded { dragOnEnd($0) })
            .animation(.default, value: currentOffset)
    }
}

// MARK: - PREVIEWS
#Preview("DraggableYouTubePlayerView") {
    DraggableYouTubePlayerView(videoID: "6R8ffRRJcrg") {
        print("PiP Closed!")
    }
}

extension DraggableYouTubePlayerView {
    // MARK: - FUNCTIONS
    
    // MARK: - dragOnChange
    private func dragOnChange(_ gesture: DragGesture.Value) {
        // Calculate new position
        var newOffsetX = gesture.translation.width + lastOffset.width
        var newOffsetY = gesture.translation.height + lastOffset.height
        
        // Constrain the movement within the screen bounds
        newOffsetX = min(max(newOffsetX, -screenWidth / 2 + rectWidth / 2), screenWidth / 2 - rectWidth / 2)
        newOffsetY = min(max(newOffsetY, -screenHeight / 2 + rectHeight / 2), screenHeight / 2 - rectHeight / 2)
        
        // Update the offset
        currentOffset = CGSize(width: newOffsetX - lastOffset.width, height: newOffsetY - lastOffset.height)
        isDragging = true
    }
    
    // MARK: - dragOnEnd
    private func dragOnEnd(_ gesture: DragGesture.Value) {
        // Save the final position and reset the temporary offset
        lastOffset.width += currentOffset.width
        lastOffset.height += currentOffset.height
        currentOffset = .zero
        isDragging = false
    }
}
