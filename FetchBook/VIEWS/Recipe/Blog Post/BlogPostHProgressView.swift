//
//  BlogPostHProgressView.swift
//  FetchBook
//
//  Created by Mr. Kavinda Dilshan on 2024-10-06.
//

import SwiftUI

struct BlogPostHProgressView: View {
    // MARK: - PROPERTIES
    let progress: CGFloat
    
    // MARK: - INITIALIZER
    init(progress: CGFloat) {
        self.progress = progress
    }
    
    // MARK: - BODY
    var body: some View {
        Rectangle()
            .fill(Color(uiColor: .systemGray6))
            .frame(height: 2)
            .overlay(alignment: .leading) {
                Rectangle()
                    .fill(.blue)
                    .frame(width: Helpers.screenWidth * progress)
            }
            .opacity(progress == 1 ? 0 : 1)
    }
}

// MARK: - PREVIEWS
#Preview("BlogPostHProgressView") {
    BlogPostHProgressView(progress: 0.7)
}
