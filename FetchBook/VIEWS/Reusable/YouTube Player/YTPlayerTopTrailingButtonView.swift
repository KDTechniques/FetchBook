//
//  YTPlayerTopTrailingButtonView.swift
//  FetchBook
//
//  Created by Mr. Kavinda Dilshan on 2024-10-06.
//

import SwiftUI

struct YTPlayerTopTrailingButtonView: View {
    // MARK: - INITIAL PROPERTIES
    let isDragging: Bool
    let action: () -> ()
    
    // MARK: - INITIALIZER
    init(isDragging: Bool, action: @escaping () -> ()) {
        self.isDragging = isDragging
        self.action = action
    }
    
    // MARK: - PRIVATE PROPERTIES
    private let iconSize: CGFloat = 20
    private let iconPadding: CGFloat = 6
    
    // MARK: - BODY
    var body: some View {
        Image(systemName: SystemImageAssetsValues.youtubePlayerDragging(isDragging))
            .resizable()
            .scaledToFit()
            .frame(width: iconSize, height: iconSize)
            .padding(iconPadding)
            .background(.ultraThinMaterial)
            .clipShape(Circle())
            .offset(y: -(iconSize+(iconPadding*3)))
            .onTapGesture { action() }
            .animation(.none, value: isDragging)
    }
}

// MARK: - PREVIEWS
#Preview("YTPlayerTopTrailingButtonView") {
    YTPlayerTopTrailingButtonView(isDragging: .random()) {
        print("Action triggered!")
    }
}
