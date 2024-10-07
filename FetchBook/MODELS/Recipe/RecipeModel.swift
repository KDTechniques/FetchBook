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

struct RecipeModel: Identifiable, Codable, Equatable {
    // MARK: - PROPERTIES
    let id: String
    let name: String
    let cuisine: String
    private let photoURLLargeString: String
    private let thumbnailURLString: String
    private let blogPostURLString: String?
    private let youtubeURLString: String?
    
    // Computed properties to ensure URLs are always in HTTPS format
    var securePhotoURLLargeString: String {
        photoURLLargeString.replacingOccurrences(of: "http://", with: "https://")
    }
    
    var secureThumbnailURLString: String {
        thumbnailURLString.replacingOccurrences(of: "http://", with: "https://")
    }
    
    var secureBlogPostURLString: String? {
        blogPostURLString?.replacingOccurrences(of: "http://", with: "https://")
    }
    
    var secureYoutubeURLString: String? {
        youtubeURLString?.replacingOccurrences(of: "http://", with: "https://")
    }
    
    static let mockObject: Self = .init(
        id: "9dd84450-9922-463a-bece-64f32f7a7dc5",
        name: "Summer Pudding",
        cuisine: "British",
        photoURLLargeString: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/d7f2d753-a434-426b-afdd-c63b899bcac1/large.jpg",
        thumbnailURLString: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/d7f2d753-a434-426b-afdd-c63b899bcac1/small.jpg",
        blogPostURLString: "https://www.bbcgoodfood.com/recipes/4516/summer-pudding",
        youtubeURLString: "https://www.youtube.com/watch?v=akJIO6UhXtA"
    )
    
    // MARK: - CODING KEYS
    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case name
        case cuisine
        case photoURLLargeString = "photo_url_large"
        case thumbnailURLString = "photo_url_small"
        case blogPostURLString = "source_url"
        case youtubeURLString = "youtube_url"
    }
}
