//
//  BlogPostItemModel.swift
//  FetchBook
//
//  Created by Mr. Kavinda Dilshan on 2024-10-18.
//

import Foundation

/// A model representing an individual blog post item, containing relevant URLs and display options.
///
/// This struct includes:
/// - `secureBlogPostURLString`: An optional string representing the secure URL (HTTPS) of the blog post.
///   This is used to display or link to the blog post's content. If `nil`, the blog post may not have an associated URL.
/// - `secureYoutubeURLString`: An optional string representing the secure URL (HTTPS) of the associated YouTube video.
///   This is used to link to or embed a video related to the blog post. If `nil`, no video is associated with the blog post.
/// - `showVideoPlayer`: A Boolean value indicating whether a video player should be displayed in the UI.
///   If `true`, the video player should be shown, potentially using `secureYoutubeURLString` as the source. If `false`, no video player is displayed.
struct BlogPostItemModel: Hashable {
    /// The secure URL string for the blog post.
    let secureBlogPostURLString: String?
    
    /// The secure YouTube URL string, if the post includes a video.
    let secureYoutubeURLString: String?
    
    /// Whether to display a video player in the UI.
    let showVideoPlayer: Bool
}
