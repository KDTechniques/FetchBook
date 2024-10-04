//
//  RecipeModel.swift
//  FetchBook
//
//  Created by Mr. Kavinda Dilshan on 2024-10-05.
//

import Foundation

struct RecipeModel {
    // MARK: - PROPERTIES
    let uuid: String
    let name: String
    let cuisine: String
    let photoURLLarge: String
    let thumbnail: String
    let blogPostURL: String
    let youtubeURL: String
    
    // MARK: - INITIALIZER
    init(uuid: String, name: String, cuisine: String, photoURLLarge: String, thumbnail: String, blogPostURL: String, youtubeURL: String) {
        self.uuid = uuid
        self.name = name
        self.cuisine = cuisine
        self.photoURLLarge = photoURLLarge
        self.thumbnail = thumbnail
        self.blogPostURL = blogPostURL
        self.youtubeURL = youtubeURL
    }
}
