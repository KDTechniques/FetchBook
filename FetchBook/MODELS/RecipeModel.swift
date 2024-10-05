//
//  RecipeModel.swift
//  FetchBook
//
//  Created by Mr. Kavinda Dilshan on 2024-10-05.
//

import Foundation

struct RecipesModel: Codable {
    let recipes: [RecipeModel]
}

struct RecipeModel: Identifiable, Codable {
    // MARK: - PROPERTIES
    let id: String
    let name: String
    let cuisine: String
    let photoURLLarge: String
    let thumbnail: String
    let blogPostURL: String?
    let youtubeURL: String?
    
    // MARK: - CODING KEYS
    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case name
        case cuisine
        case photoURLLarge = "photo_url_large"
        case thumbnail = "photo_url_small"
        case blogPostURL = "source_url"
        case youtubeURL = "youtube_url"
    }
}
