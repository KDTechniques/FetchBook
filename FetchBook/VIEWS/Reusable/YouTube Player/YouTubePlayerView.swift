//
//  YouTubePlayerView.swift
//  FetchBook
//
//  Created by Mr. Kavinda Dilshan on 2024-10-21.
//

import SwiftUI
import YouTubeiOSPlayerHelper

/// A UIViewRepresentable to wrap the YTPlayerView
struct YouTubePlayerView: UIViewRepresentable {
    // MARK: - PROPERTIES
    let videoID: String
    @Binding var isLoading: Bool
    
    // MARK: FUNCTIONS
    
    // MARK: - makeCoordinator
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    // MARK: - makeUIView
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        let url = URL(string: "https://www.youtube.com/embed/\(videoID)")!
        webView.load(URLRequest(url: url))
        return webView
    }
    
    // MARK: - updateUIView
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // No need for updates here
    }
    
    // MARK: - Coordinator
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
}
