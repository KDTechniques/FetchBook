//
//  DraggableYouTubePlayerView.swift
//  FetchBook
//
//  Created by Mr. Kavinda Dilshan on 2024-10-05.
//

import SwiftUI
import YouTubeiOSPlayerHelper

// A UIViewRepresentable to wrap the YTPlayerView
struct YouTubePlayerView: UIViewRepresentable {
    let videoID: String
    @Binding var isLoading: Bool
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: YouTubePlayerView
        
        init(parent: YouTubePlayerView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            parent.isLoading = true
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.isLoading = false
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        let url = URL(string: "https://www.youtube.com/embed/\(videoID)")!
        webView.load(URLRequest(url: url))
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // No need for updates here
    }
}

struct DraggableYouTubePlayerView: View {
    // MARK: - PROPERTIES
    let videoID: String
    let action: () -> ()
    
    // MARK: - PRIVATE PROPERTIES
    @State private var offset = CGSize.zero // Current drag offset
    @State private var lastOffset = CGSize.zero // Cumulative offset after each drag
    @State private var isDragging: Bool = false
    @State private var isLoading: Bool = true
    
    let screenWidth = UIScreen.main.bounds.width - 50
    let screenHeight = UIScreen.main.bounds.height - 80
    let rectWidth: CGFloat = UIScreen.main.bounds.size.width - 150
    private var rectHeight: CGFloat { rectWidth/16*9 } // 16:9 Ratio
    let iconSize: CGFloat = 20
    let iconPadding: CGFloat = 6
    
    // MARK: INITIALIZER
    init(videoID: String, action: @escaping () -> ()) {
        self.videoID = videoID
        self.action = action
    }
    
    // MARK: - BODY
    var body: some View {
        YouTubePlayerView(videoID: videoID, isLoading: $isLoading)
            .overlay {
                if isLoading {
                    Group {
                        Color(uiColor: .systemGray3)
                        ProgressView()
                            .scaleEffect(1.2)
                    }
                }
            }
            .clipShape(.rect(cornerRadius: 10))
            .overlay(alignment: .topTrailing) {
                Image(systemName: isDragging ? "arrow.up.and.down.and.arrow.left.and.right" : "pip.remove")
                    .resizable()
                    .scaledToFit()
                    .frame(width: iconSize, height: iconSize)
                    .padding(iconPadding)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
                    .offset(y: -(iconSize+(iconPadding*3)))
                    .onTapGesture { action() }
                    .animation(.none, value: isDragging)
            }
            .frame(width: rectWidth, height: rectHeight)
            .offset(x: offset.width + lastOffset.width, y: offset.height + lastOffset.height)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
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
                    .onEnded { _ in
                        // Save the final position and reset the temporary offset
                        lastOffset.width += offset.width
                        lastOffset.height += offset.height
                        offset = .zero
                        isDragging = false
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
