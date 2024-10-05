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
    @StateObject private var recipeVM: RecipeViewModel = .init()
    
    @State private var progress: Double = .zero
    @State private var showVideoPlayer: Bool = false
    
    enum FetchConditions {
        case initial
        case refresh
    }
    
    // MARK: - BODY
    var body: some View {
        NavigationStack {
            List(recipeVM.recipesArray) { recipe in
                HStack {
                    Group {
                        if let url: URL = .init(string: recipe.photoURLLarge) {
                            WebImage(url: url, options: [.retryFailed, .progressiveLoad])
                                .placeholder {
                                    Rectangle()
                                        .fill(.secondary)
                                }
                                .resizable()
                                .scaledToFit()
                            
                        } else {
                            Rectangle()
                                .fill(.secondary)
                        }
                    }
                    .frame(width: 80, height: 80)
                    .clipShape(.rect(cornerRadius: 10))
                    
                    NavigationLink {
                        if let urlString: String = recipe.blogPostURL,
                           let url: URL = .init(string: urlString) {
                            VStack(spacing: 0) {
                                Rectangle()
                                    .fill(Color(uiColor: .systemGray6))
                                    .frame(height: 2)
                                    .overlay(alignment: .leading) {
                                        Rectangle()
                                            .fill(.blue)
                                            .frame(width: UIScreen.main.bounds.size.width * progress)
                                    }
                                    .opacity(progress == 1 ? 0 : 1)
                                
                                WebViewWithProgress(url: url, progress: $progress)
                            }
                            .overlay {
                                if showVideoPlayer {
                                    DraggableYouTubePlayerView(videoID: "6R8ffRRJcrg") {
                                        showVideoPlayer = false
                                    }
                                }
                            }
                            .ignoresSafeArea(edges: .bottom)
                            .toolbar {
                                ToolbarItem(placement: .topBarTrailing) {
                                    Button {
                                        showVideoPlayer = true
                                    } label: {
                                        Image(systemName: "play.circle")
                                    }
                                }
                            }
                            .navigationTitle("Blog Post")
                            .navigationBarTitleDisplayMode(.inline)
                        }
                    } label: {
                        VStack(alignment: .leading) {
                            Text(recipe.name)
                            
                            Text(recipe.cuisine)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .task(priority: .high) { loadData(.initial, endpoint: .all) }
            .refreshable { loadData(.refresh, endpoint: .all) }
            .navigationTitle("Recipes")
        }
    }
}

// MARK: - PREVIEWS
#Preview("RecipesView") {
    RecipesView()
}

extension RecipesView {
    // MARK: - fetchData
    private func fetchData(endpoint: RecipeViewModel.Endpoints) {
        Task {
            do {
                try await recipeVM.fetchRecipeData(endpoint: endpoint)
            } catch {
                print("Error fetching recipes: \(error)")
                // show an alert here...
            }
        }
    }
    
    private func loadData(_ condition: FetchConditions, endpoint: RecipeViewModel.Endpoints) {
        switch condition {
        case .initial:
            recipeVM.recipesArray.isEmpty ? fetchData(endpoint: endpoint) : ()
            
        case .refresh:
            fetchData(endpoint: endpoint)
        }
    }
}
