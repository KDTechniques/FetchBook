//
//  SystemImageAssetsValues.swift
//  FetchBook
//
//  Created by Kavinda Dilshan on 2024-11-18.
//

import Foundation

struct SystemImageAssetsValues {
    /// Note: You may use computed properties to check OS version and set the supported SF Symbols if needed.
    /// Ex: static var sortingMenuButton: String {
    ///         if #available(iOS 14.0, *) {
    ///             return "arrow.up.arrow.down.circle"
    ///         } else {
    ///             return "arrow.up.arrow.down"
    ///         }
    ///     }
    ///
    static let sortingMenuButton: String = "arrow.up.arrow.down"
    static let noSavedEpisodes: String = "bookmark"
    static let noRecipes: String = "book"
    static let malformedRecipes: String = "exclamationmark.icloud"
    static let emptyRecipes: String = "fork.knife"
    static let youtubePlayButton: String = "play.circle"
    static let blogPostButton: String = "book"
    static let recipesTab: String = "book.fill"
    static let debugTab: String = "wrench.and.screwdriver.fill"
    static func youtubePlayerDragging(_ isDragging: Bool) -> String {
        return isDragging
        ? "arrow.up.and.down.and.arrow.left.and.right"
        : "pip.remove"
    }
}
