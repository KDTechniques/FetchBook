//
//  CustomContentNotAvailableView.swift
//  Sleepi
//
//  Created by Mr. Kavinda Dilshan on 2023-11-08.
//

import SwiftUI

struct CustomContentNotAvailableView: View {
    // MARK: - INITIAL PROPERTIES
    let item: ContentNotAvailableModel
    
    // MARK: - INITIALIZER
    init(_ item: ContentNotAvailableModel) {
        self.item = item
    }
    
    // MARK: - BODY
    var body: some View {
        VStack(spacing: 8) {
            systemImage
            title
            description
        }
        .padding(.horizontal, 30)
    }
}

// MARK: - PREVIEWS
#Preview("CustomContentNotAvailableView") {
    CustomContentNotAvailableView(ContentNotAvailableValues.mockAll)
}

#Preview("Only Title") {
    CustomContentNotAvailableView(ContentNotAvailableValues.mockTitleOnly)
}

#Preview("Only Title & Description") {
    CustomContentNotAvailableView(ContentNotAvailableValues.mockTitleNDescriptionOnly)
}

// MARK: - EXTENSIONS
extension CustomContentNotAvailableView {
    // MARK: - systemImage
    @ViewBuilder
    private var systemImage: some View {
        if let systemImageName = item.systemImageName {
            Image(systemName: systemImageName)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundStyle(.secondary)
                .padding(.bottom, 4)
        }
    }
    
    // MARK: - title
    private var title: some View {
        Text(item.title)
            .font(.title2.weight(.bold))
            .lineLimit(1)
            .minimumScaleFactor(0.9)
    }
    
    // MARK: - description
    @ViewBuilder
    private var description: some View {
        if let description = item.description {
            Text(description)
                .font(.callout)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(3)
                .fixedSize(horizontal: false, vertical: true)
                .minimumScaleFactor(0.9)
        }
    }
}
