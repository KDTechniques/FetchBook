//
//  RecipeImageValues.swift
//  FetchBook
//
//  Created by Mr. Kavinda Dilshan on 2024-10-18.
//

import Foundation

/// A utility struct that defines constant values for configuring the layout and appearance of recipe images.
///
/// This struct includes:
/// - `cornerRadius`: The corner radius applied to the outer image frame.
/// - `spacing`: The spacing between the outer and inner frames, used for padding or gaps.
/// - `frameSize`: The size of the outer frame for the recipe image.
/// - `innerFrameSize`: A computed property that calculates the size of the inner frame based on the outer `frameSize` and `spacing`.
///   This ensures the inner frame is smaller and properly spaced within the outer frame.
/// - `innerCornerRadius`: A computed property that calculates the corner radius for the inner frame based on the outer `cornerRadius` and `spacing`.
///   This allows for consistent visual styling, ensuring the inner frame's corners are slightly smaller than the outer frame's corners.
struct RecipeImageValues {
    /// Outer corner radius of the recipe image.
    static let cornerRadius: CGFloat = 15
    
    /// Spacing between the outer and inner frames.
    static let spacing: CGFloat = 2
    
    /// Outer frame size for the recipe image.
    static let frameSize: CGFloat = 80
    
    /// The size of the inner frame, adjusted for the spacing.
    static var innerFrameSize: CGFloat {
        return frameSize - (spacing * 2)
    }
    
    /// The corner radius for the inner frame, adjusted for the spacing.
    static var innerCornerRadius: CGFloat {
        return cornerRadius - spacing
    }
}
