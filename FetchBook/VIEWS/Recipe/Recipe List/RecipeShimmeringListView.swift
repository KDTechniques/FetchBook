//
//  RecipeShimmeringListView.swift
//  FetchBook
//
//  Created by Mr. Kavinda Dilshan on 2024-10-07.
//

import SwiftUI
import Shimmer

struct RecipeShimmeringListView: View {
    // MARK: - BODY
    var body: some View {
        List(0...10, id: \.self) { _ in
            HStack(alignment: .top) {
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(Color(uiColor: .systemGray3), lineWidth: 2)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color(uiColor: .systemGray4)))
                    .frame(width: 80, height: 80)
                
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
            .listRowBackground(Color.clear)
            .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 0))
            .shimmering(active: true, duration: 1, bounce: false, delay: 0.3)
        }
    }
}

//  MARK: - PREVIEWS
#Preview("RecipeShimmeringListView") {
    RecipeShimmeringListView()
}
