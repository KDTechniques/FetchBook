//
//  RecipeImageView.swift
//  FetchBook
//
//  Created by Mr. Kavinda Dilshan on 2024-10-06.
//

import SwiftUI
import SDWebImageSwiftUI

struct RecipeImageView: View {
    // MARK: - INITIAL PROPERTIES
    let thumbnailImageURLString: String
    let largeImageURLString: String
    
    // MARK: - INITIALIZER
    init(thumbnailImageURLString: String, largeImageURLString: String) {
        self.thumbnailImageURLString = thumbnailImageURLString
        self.largeImageURLString = largeImageURLString
    }
    
    // MARK: - PRIVATE PROPERTIES
    private let values = RecipeImageValues.self
    
    // MARK: - BODY
    var body: some View {
        imageLoader(
            thumbnailImageURL: .init(string: thumbnailImageURLString) ,
            largeImageURL: .init(string: largeImageURLString)
        )
    }
}

// MARK: - PREVIEWS
#Preview("RecipeImageView") {
    var thumbnailImageURLString: String { "https://d3jbb8n5wk0qxi.cloudfront.net/photos/7f6a259a-71df-42c2-b314-065e0c736c67/small.jpg" }
    var largeImageURLString: String { "https://d3jbb8n5wk0qxi.cloudfront.net/photos/7f6a259a-71df-42c2-b314-065e0c736c67/large.jpg" }
    
    RecipeImageView(thumbnailImageURLString: thumbnailImageURLString, largeImageURLString: largeImageURLString)
        .scaleEffect(3)
        .onTapGesture {
            SDImageCache.shared.clearDisk {
                print("All cache cleared from memory and disk!")
            }
        }
}

// MARK: - EXTENSIONS
extension RecipeImageView {
    // MARK: - thumbnailImage
    private func thumbnailImage(_ url: URL?) -> some View {
        WebImage(url: url, options: [.retryFailed, .highPriority])
            .placeholder {
                RecipeImagePlaceholderView()
            }
            .resizable()
            .scaledToFill()
    }
    
    // MARK: - image
    private func imageLoader(thumbnailImageURL: URL?, largeImageURL: URL?) -> some View {
        RecipeImageBackgroundRoundedRectangleView()
            .overlay {
                WebImage(url: largeImageURL, options: [.retryFailed, .lowPriority])
                    .placeholder {
                        thumbnailImage(thumbnailImageURL)
                    }
                    .resizable()
                    .scaledToFill()
                    .frame(width: values.innerFrameSize, height: values.innerFrameSize)
                    .clipShape(.rect(cornerRadius: values.innerCornerRadius))
            }
    }
}
