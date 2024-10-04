//
//  RecipesView.swift
//  FetchBook
//
//  Created by Mr. Kavinda Dilshan on 2024-10-05.
//

import SwiftUI
import SDWebImageSwiftUI

struct RecipesView: View {
    // MARK: - PROPERTIES
    
    
    // MARK: - BODY
    var body: some View {
        NavigationStack {
            List(0...10, id: \.self) { _ in
                HStack {
                    WebImage(url: .init(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg")!)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .clipShape(.rect(cornerRadius: 10))
                    
                    NavigationLink {
                        Text("Testing...")
                    } label: {
                        VStack(alignment: .leading) {
                            Text("Apam Balik")
                            
                            Text("Malaysian")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .task(priority: .high) {
                /// initial network call goes here
                print("Network call on appear")
            }
            .refreshable {
                /// refreshable code goes here
                print("refreshed.")
            }
            .navigationTitle("Recipes")
        }
    }
}

// MARK: - PREVIEWS
#Preview("RecipesView") {
    RecipesView()
}
