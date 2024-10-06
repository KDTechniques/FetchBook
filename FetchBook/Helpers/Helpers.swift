//
//  Helpers.swift
//  FetchBook
//
//  Created by Mr. Kavinda Dilshan on 2024-10-05.
//

import Foundation

struct Helpers {
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
    
}
