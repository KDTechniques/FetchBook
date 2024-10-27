//
//  Global Helpers.swift
//  FetchBook
//
//  Created by Mr. Kavinda Dilshan on 2024-10-05.
//

import SDWebImageSwiftUI
import WebKit
import SwiftUI

struct Helpers {
    // MARK: - PROPERTIES
    static let screenWidth: CGFloat = UIScreen.main.bounds.size.width
    static let screenHeight: CGFloat = UIScreen.main.bounds.size.height
    
    // MARK: - FUNCTIONS
    
    // MARK: - extractYouTubeVideoID
    // Extract video ID from a YouTube URL.
    ///
    /// This function takes a YouTube video URL as a string and uses a regular expression
    /// to extract the video ID from the URL. The video ID is typically a string of 11
    /// alphanumeric characters and is used to uniquely identify a YouTube video.
    ///
    /// - Parameter url: A string representing the YouTube video URL from which to extract the video ID.
    /// - Returns: An optional string containing the video ID if found, or `nil` if the URL is invalid
    ///            or does not contain a valid video ID.
    static func extractYouTubeVideoID(from url: String) -> String? {
        // Define a regular expression pattern to match the video ID in the YouTube URL.
        let pattern = #"(?<=v=)[\w-]{11}"# // Matches the video ID after 'v=' in the URL.
        
        // Attempt to find a range of the video ID in the provided URL using the regex pattern.
        if let range = url.range(of: pattern, options: .regularExpression) {
            // Return the extracted video ID as a string.
            return String(url[range])
        }
        
        // Return nil if the video ID was not found.
        return nil
    }
    
    // MARK: - clearImageCache
    /// Clears the image cache from both memory and disk storage.
    ///
    /// This function removes all cached images from the memory and disk. Once the disk cache is cleared,
    /// a message is printed to indicate that the operation was successful.
    static func clearImageCache() {
        let imageCache = SDImageCache.shared
        
        imageCache.clearMemory()
        imageCache.clearDisk { print("Image cache cleared from disk.") }
        
        print("Image cache cleared from memory.")
    }
    
    // MARK: - preloadWebView
    /// Preloads a hidden `WKWebView` to warm up the WebKit process and avoid delays during subsequent WebView usage.
    ///
    /// This function preloads a `WKWebView` by loading a lightweight page (`about:blank`) on the main thread.
    /// This warms up the WebKit process to reduce any potential delay when the user navigates to a webpage for the first time.
    static func preloadWebView() async {
        let webView = await WKWebView(frame: .zero)
        let dummyURL = URL(string: "about:blank")! // Load a blank page or a simple local page
        let request = URLRequest(url: dummyURL)
        await webView.load(request)
    }
    
    // MARK: - generatePermutations
    /// Generates all unique permutations of the elements in the provided array.
    ///
    /// This function uses recursion and Swift's high-order functions to generate all unique permutations
    /// of the array elements.
    ///
    /// - Parameter array: The array of elements to permute.
    /// - Returns: An array containing all unique permutations of the input array.
    static func generatePermutations<T>(_ array: [T]) -> [[T]] {
        // Base case: if the array has 0 or 1 elements, return the array as the only permutation.
        guard array.count > 1 else { return [array] }
        
        // Use flatMap to generate all permutations by fixing each element at the first position
        // and recursively generating permutations for the remaining elements.
        return array.indices.flatMap { index in
            // Create a mutable copy of the array and remove the element at the current index.
            var remainingElements = array
            let element = remainingElements.remove(at: index)
            
            // Recursively generate permutations for the remaining elements and prepend the fixed element.
            return generatePermutations(remainingElements).map { [element] + $0 }
        }
    }
    
}
