//
//  RecipeImageBackgroundRoundedRectangleView.swift
//  FetchBook
//
//  Created by Mr. Kavinda Dilshan on 2024-10-18.
//

import SwiftUI

struct RecipeImageBackgroundRoundedRectangleView: View {
    // MARK: - INITIAL PROPERTIES
    let values = RecipeImageValues.self
    
    // MARK: - BODY
    var body: some View {
        RoundedRectangle(cornerRadius: values.outerCornerRadius)
            .fill(Color(uiColor: .systemGray5))
            .frame(width: values.frameSize, height: values.frameSize)
    }
}

// MARK: - PREVIEWS
#Preview("RecipeImageBackgroundRoundedRectangleView") {
    RecipeImageBackgroundRoundedRectangleView()
}
