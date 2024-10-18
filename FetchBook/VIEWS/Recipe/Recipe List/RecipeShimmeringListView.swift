//
//  RecipeShimmeringListView.swift
//  FetchBook
//
//  Created by Mr. Kavinda Dilshan on 2024-10-07.
//

import SwiftUI
import Shimmer

struct RecipeShimmeringListView: View {
    // MARK: - PROPERTIES
    let array: [Int] = Array(0...10)
    
    // MARK: - BODY
    var body: some View {
        List(array, id: \.self) {
            HStack(alignment: .top) {
                RecipeImagePlaceholderView()
                
                VStack(alignment: .leading) {
                    Text("Recipe name goes here")
                        .opacity(0)
                        .background(Color(uiColor: .systemGray3))
                    
                    Text("Cuisine here")
                        .font(.subheadline)
                        .opacity(0)
                        .background(Color(uiColor: .systemGray3))
                }
                .padding(.top, 10)
            }
            .listRowSeparator($0 == array.first ? .hidden : .visible, edges: .top)
            .listRowSeparator($0 == array.last ? .hidden : .visible, edges: .bottom)
            .shimmering(active: true, duration: 1, bounce: false, delay: 0.3)
        }
        .listStyle(.plain)
    }
}

//  MARK: - PREVIEWS
#Preview("RecipeShimmeringListView") {
    RecipeShimmeringListView()
}
