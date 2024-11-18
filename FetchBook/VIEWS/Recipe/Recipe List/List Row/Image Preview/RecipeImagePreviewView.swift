//
//  RecipeImagePreviewView.swift
//  FetchBook
//
//  Created by Mr. Kavinda Dilshan on 2024-10-18.
//

import SwiftUI
import SDWebImageSwiftUI

struct RecipeImagePreviewView: View {
    // MARK: - INITIAL PROPERTIES
    let recipe: RecipeModel
    
    // MARK: - INITIALIZER
    init(recipe: RecipeModel) {
        self.recipe = recipe
    }
    
    // MARK: - PRIVATE PROPERTIES
    private let recipeImagePreviewSize: CGFloat = Helpers.screenWidth - 100
    
    // MARK: - BODY
    var body: some View {
        largeImage
            .frame(width: recipeImagePreviewSize, height: recipeImagePreviewSize)
            .overlay(alignment: .bottomLeading) {
                recipeInfo
            }
    }
}

// MARK: - PREVIEWS
#Preview("RecipeImagePreviewView") {
    RecipeImagePreviewView(recipe: .mockObject)
}

extension RecipeImagePreviewView {
    // MARK: - placeholder
    private var placeholder: some View {
        Color.secondary
            .overlay {
                ProgressView()
                    .scaleEffect(2)
            }
    }
    
    // MARK: - thumbnailImage
    private var thumbnailImage: some View {
        WebImage(
            url: .init(string: recipe.secureThumbnailURLString),
            options: [.highPriority, .retryFailed]
        )
        .placeholder {
            placeholder
        }
        .resizable()
        .scaledToFill()
    }
    
    // MARK: - largeImage
    private var largeImage: some View {
        WebImage(
            url: .init(string: recipe.securePhotoURLLargeString),
            options: [.lowPriority, .retryFailed]
        )
        .placeholder {
            thumbnailImage
        }
        .resizable()
        .scaledToFill()
    }
    
    // MARK: - recipeInfo
    private var recipeInfo: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(recipe.name)
                .font(.title.bold())
                .foregroundStyle(.white)
            
            Text(recipe.cuisine)
                .foregroundStyle(.white.opacity(0.8))
        }
        .shadow(radius: 5)
        .padding()
    }
}
