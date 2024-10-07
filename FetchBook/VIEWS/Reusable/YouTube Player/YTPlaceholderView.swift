//
//  YTPlaceholderView.swift
//  FetchBook
//
//  Created by Mr. Kavinda Dilshan on 2024-10-06.
//

import SwiftUI

struct YTPlaceholderView: View {
    // MARK: - PROPERTIES
    let showPlaceholder: Bool
    
    // MARK: - INITIALIZER
    init(showPlaceholder: Bool) {
        self.showPlaceholder = showPlaceholder
    }
    
    //  MARK: - BODY
    var body: some View {
        if showPlaceholder {
            Group {
                Color(uiColor: .systemGray3)
                ProgressView()
                    .scaleEffect(1.2)
            }
        } else { EmptyView() }
    }
}

//  MARK: - PREVIEWS
#Preview("YTPlaceholderView") {
    ZStack {
        YTPlaceholderView(showPlaceholder: true)
            .frame(width: 300, height: 200)
            .clipShape(.rect(cornerRadius: 12))
    }
}
