//
//  BlogPostItemModel.swift
//  FetchBook
//
//  Created by Mr. Kavinda Dilshan on 2024-10-18.
//

import Foundation

/// A model representing an individual blog post item, containing relevant URLs and display options.
struct BlogPostItemModel: Hashable {
    /// An optional string representing the secure URL (HTTPS) of the blog post.
    /// This is used to display or link to the blog post's content. If `nil`, the blog post may not have an associated URL.
    let secureBlogPostURLString: String?
    
    /// An optional string representing the secure URL (HTTPS) of the associated YouTube video.
    /// This is used to link to or embed a video related to the blog post. If `nil`, no video is associated with the blog post.
    let secureYoutubeURLString: String?
    
    /// A Boolean value indicating whether a video player should be displayed in the UI.
    /// If `true`, the video player should be shown, potentially using `secureYoutubeURLString` as the source. If `false`, no video player is displayed.
    let showVideoPlayer: Bool
}
