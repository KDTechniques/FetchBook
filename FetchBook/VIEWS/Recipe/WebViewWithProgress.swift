//
//  WebViewWithProgress.swift
//  FetchBook
//
//  Created by Mr. Kavinda Dilshan on 2024-10-05.
//

import SwiftUI
import WebKit

struct WebViewWithProgress: UIViewRepresentable {
    let url: URL
    @Binding var progress: Double // Binding to a SwiftUI state for progress updates
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator // Set navigation delegate
        webView.addObserver(context.coordinator, forKeyPath: "estimatedProgress", options: .new, context: nil) // Observe loading progress
        let request = URLRequest(url: url)
        webView.load(request)
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // You can handle any updates if necessary
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebViewWithProgress
        
        init(_ parent: WebViewWithProgress) {
            self.parent = parent
        }
        
        // Observe progress changes
        override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            if keyPath == "estimatedProgress", let webView = object as? WKWebView {
                DispatchQueue.main.async {
                    self.parent.progress = webView.estimatedProgress
                }
            }
        }
        
        // Cleanup observer when web view is deallocated
        deinit {
            parent.progress = 0.0 // Reset progress when done
        }
    }
}
