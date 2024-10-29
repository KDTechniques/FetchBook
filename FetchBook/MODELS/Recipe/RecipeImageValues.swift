//
//  RecipeImageValues.swift
//  FetchBook
//
//  Created by Mr. Kavinda Dilshan on 2024-10-18.
//

import Foundation

/// A utility struct that defines constant values for configuring the layout and appearance of recipe images.
struct RecipeImageValues {
    /// The corner radius applied to the outer image frame.
    static let outerCornerRadius: CGFloat = 15
    
    /// The spacing between the outer and inner frames, used for padding or gaps.
    static let spacing: CGFloat = 2
    
    /// The size of the outer frame for the recipe image.
    static let frameSize: CGFloat = 80
    
    /// Calculates the size of the inner frame based on the outer `frameSize` and `spacing`.
    /// This ensures the inner frame is smaller and properly spaced within the outer frame.
    static var innerFrameSize: CGFloat {
        return frameSize - (spacing * 2)
    }
    
    /// Calculates the corner radius for the inner frame based on the `outerCornerRadius` and `spacing`.
    /// This allows for consistent visual styling, ensuring the inner frame's corners are slightly smaller than the outer frame's corners.
    static var innerCornerRadius: CGFloat {
        return outerCornerRadius - spacing
    }
}
