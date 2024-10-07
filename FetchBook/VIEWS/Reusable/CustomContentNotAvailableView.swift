//
//  CustomContentNotAvailableView.swift
//  Sleepi
//
//  Created by Mr. Kavinda Dilshan on 2023-11-08.
//

import SwiftUI

struct CustomContentNotAvailableView: View {
    // MARK: - PROPERTIES
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
    CustomContentNotAvailableView(.init(
        systemImageName: "bookmark",
        title: "No Saved Episodes",
        description: "Save episodes you want listen to later, and they'll show up here."
    ))
}

#Preview("Only Title") {
    CustomContentNotAvailableView(.init(
        title: "No Results"
    ))
}

#Preview("Only Title & Description") {
    CustomContentNotAvailableView(.init(
        title: "No Saved Episodes",
        description: "Save episodes you want listen to later, and they'll show up here."
    ))
}

// MARK: - EXTENSIONS
extension CustomContentNotAvailableView {
    // MARK: - ContentNotAvailableModel
    struct ContentNotAvailableModel {
        // MARK:  - PROPERTIES
        let systemImageName: String?
        let title: String
        let description: String?
        
        // MARK: - INITIALIZER
        init(
            systemImageName : String? = nil,
            title           : String,
            description     : String? = nil
        ) {
            self.systemImageName    = systemImageName
            self.title              = title
            self.description        = description
        }
    }
    
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
