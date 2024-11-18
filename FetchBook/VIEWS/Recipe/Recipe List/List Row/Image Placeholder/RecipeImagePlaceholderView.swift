//
//  RecipeImagePlaceholderView.swift
//  FetchBook
//
//  Created by Mr. Kavinda Dilshan on 2024-10-18.
//

import SwiftUI

struct RecipeImagePlaceholderView: View {
    // MARK: - INITIAL PROPERTIES
    let values = RecipeImageValues.self
    
    // MARK: - BODY
    var body: some View {
        RecipeImageBackgroundRoundedRectangleView()
            .overlay {
                RoundedRectangle(cornerRadius: values.innerCornerRadius)
                    .fill(Color(uiColor: .systemGray6))
                    .frame(width: values.innerFrameSize, height: values.innerFrameSize)
            }
    }
}

// MARK: - PREVIEWS
#Preview("RecipeImagePlaceholderView") {
    RecipeImagePlaceholderView()
}
