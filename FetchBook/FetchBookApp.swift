//
//  FetchBookApp.swift
//  FetchBook
//
//  Created by Mr. Kavinda Dilshan on 2024-10-05.
//

import SwiftUI

@main
struct FetchBookApp: App {
    // MARK: - INITIALIZER
    init() {
        Task { @MainActor in
            await Helpers.preloadWebView() // Preload WebView on the main thread
        }
    }
    
    // MARK: - BODY
    var body: some Scene {
        WindowGroup {
            ContentView(recipeService: RecipeAPIService())
        }
    }
}
