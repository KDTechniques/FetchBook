//
//  WebView.swift
//  FetchBook
//
//  Created by Mr. Kavinda Dilshan on 2024-10-05.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    // MARK: - PROPERTIES
    let url: URL
    @Binding var progress: Double
    
    // Using a shared `WKProcessPool` for better performance across multiple WebViews.
    private static let sharedProcessPool = WKProcessPool()
    
    // MARK: - FUNCTIONS
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        // Configure WebView with process pool and other settings.
        let configuration = WKWebViewConfiguration()
        configuration.processPool = WebView.sharedProcessPool // Sharing process pool
        configuration.websiteDataStore = .nonPersistent() // Using `.nonPersistent()` for no cache; change to `.default` data store
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator // Set navigation delegate
        webView.addObserver(context.coordinator, forKeyPath: "estimatedProgress", options: .new, context: nil) // Observe loading progress
        
        // Keep a reference to the webView in the coordinator
        context.coordinator.webView = webView
        
        // Load the initial URL request.
        let request = URLRequest(url: url)
        webView.load(request)
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) { }
    
    // MARK: - Coordinator
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        var webView: WKWebView?
        
        init(_ parent: WebView) {
            self.parent = parent
        }
        
        // Observe progress changes
        override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            if keyPath == "estimatedProgress", let webView = object as? WKWebView {
                Task { @MainActor [weak self] in
                    guard let self else { return }
                    parent.progress = webView.estimatedProgress
                }
            }
        }
        
        deinit {
            webView?.removeObserver(self, forKeyPath: "estimatedProgress")
        }
    }
}
