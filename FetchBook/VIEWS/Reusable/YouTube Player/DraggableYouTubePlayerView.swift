//
//  DraggableYouTubePlayerView.swift
//  FetchBook
//
//  Created by Mr. Kavinda Dilshan on 2024-10-05.
//

import SwiftUI

struct DraggableYouTubePlayerView: View {
    // MARK: - INITIAL PROPERTIES
    let videoID: String
    let action: () -> ()
    
    // MARK: INITIALIZER
    init(videoID: String, action: @escaping () -> ()) {
        self.videoID = videoID
        self.action = action
    }
    
    // MARK: - PRIVATE PROPERTIES
    /// Current drag offset
    @State private var offset = CGSize.zero
    /// Cumulative offset after each drag
    @State private var lastOffset = CGSize.zero
    @State private var isDragging: Bool = false
    @State private var isLoading: Bool = true
    
    private let screenWidth = UIScreen.main.bounds.width - 50
    private let screenHeight = UIScreen.main.bounds.height - 80
    private let rectWidth: CGFloat = UIScreen.main.bounds.size.width - 150
    private var rectHeight: CGFloat { rectWidth/16*9 } // 16:9 Ratio
    
    // MARK: - BODY
    var body: some View {
        YouTubePlayerView(videoID: videoID, isLoading: $isLoading)
            .overlay {
                YTPlaceholderView(showPlaceholder: isLoading)
            }
            .clipShape(.rect(cornerRadius: 10))
            .overlay(alignment: .topTrailing) {
                YTPlayerTopTrailingButtonView(isDragging: isDragging, action: action)
            }
            .frame(width: rectWidth, height: rectHeight)
            .offset(x: offset.width + lastOffset.width, y: offset.height + lastOffset.height)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        onDragChanged(gesture)
                    }
                    .onEnded { gesture in
                        onDragEnded(gesture)
                    }
            )
            .animation(.default, value: offset)
    }
}

// MARK: - PREVIEWS
#Preview("DraggableYouTubePlayerView") {
    DraggableYouTubePlayerView(videoID: "6R8ffRRJcrg") {
        print("PiP Closed!")
    }
}

// MARK: - EXTENSIONS
extension DraggableYouTubePlayerView {
    
    // MARK: - FUNCTIONS
    private func onDragChanged(_ gesture: DragGesture.Value) {
        // Calculate new position
        var newOffsetX = gesture.translation.width + lastOffset.width
        var newOffsetY = gesture.translation.height + lastOffset.height
        
        // Constrain the movement within the screen bounds
        newOffsetX = min(max(newOffsetX, -screenWidth / 2 + rectWidth / 2), screenWidth / 2 - rectWidth / 2)
        newOffsetY = min(max(newOffsetY, -screenHeight / 2 + rectHeight / 2), screenHeight / 2 - rectHeight / 2)
        
        // Update the offset
        offset = CGSize(width: newOffsetX - lastOffset.width, height: newOffsetY - lastOffset.height)
        isDragging = true
    }
    
    // MARK: - onDragEnd
    private func onDragEnded(_ gesture: DragGesture.Value) {
        // Save the final position and reset the temporary offset
        lastOffset.width += offset.width
        lastOffset.height += offset.height
        offset = .zero
        isDragging = false
    }
}
