//
//  ContentNotAvailableValues.swift
//  FetchBook
//
//  Created by Kavinda Dilshan on 2024-11-18.
//

import Foundation

struct ContentNotAvailableValues {
    private static let imageValues = SystemImageAssetsValues.self
    
    // MARK: - Mock
    static let mockAll: ContentNotAvailableModel = .init(
        systemImageName: imageValues.noSavedEpisodes,
        title: "No Saved Episodes",
        description: "Save episodes you want listen to later, and they'll show up here."
    )
    
    static let mockTitleOnly: ContentNotAvailableModel = .init(title: "No Results")
    
    static let mockTitleNDescriptionOnly: ContentNotAvailableModel = .init(
        title: "No Saved Episodes",
        description: "Save episodes you want listen to later, and they'll show up here."
    )
    
    // MARK: - Recipes Related
    static let recipeBlogPost: ContentNotAvailableModel = .init(
        systemImageName: imageValues.noRecipes,
        title: "No Recipe Insights",
        description: "The blog post related to this recipe is currently unavailable. Please check back later or explore other recipes."
    )
    
    static let malformedRecipes: ContentNotAvailableModel = .init(
        systemImageName: imageValues.malformedRecipes,
        title: "No Recipes",
        description: "We're having trouble loading the recipes right now. Please try again later."
    )
    
    static let emptyDataRecipes: ContentNotAvailableModel = .init(
        systemImageName: imageValues.emptyRecipes,
        title: "No Recipes",
        description: "Recipes are currently unavailable from our end. Please check back later."
    )
    
    static let emptyRecipeSearchResults: ContentNotAvailableModel = .init(title: "No Results")
}
