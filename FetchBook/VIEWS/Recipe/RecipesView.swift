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
    @StateObject private var recipeVM: RecipeViewModel
    
    @State private var progress: Double = .zero
    @State private var showVideoPlayer: Bool = false
    
    enum FetchConditions {
        case initial
        case refresh
    }
    
    // MARK: - INITIALIZER
    init(recipeService: RecipeDataFetching) {
        _recipeVM = StateObject(wrappedValue: RecipeViewModel(recipeService: recipeService))
    }
    
    // MARK: - BODY
    var body: some View {
        NavigationStack {
            List(recipeVM.sortedRecipesArray) { recipe in
                let videoID: String? = Helpers.extractYouTubeVideoID(from: recipe.youtubeURL ?? "")
                
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
                                if let videoID: String = videoID, showVideoPlayer {
                                    DraggableYouTubePlayerView(videoID: videoID) {
                                        showVideoPlayer = false
                                    }
                                    .onDisappear { showVideoPlayer = false }
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
                        } else  {
                            CustomContentNotAvailableView(.init(systemImageName: "xmark", title: "title", description: "description"))
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
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Menu {
                        Picker(selection: $recipeVM.selectedSortOption, label: Text("Sorting options")) {
                            ForEach(RecipeViewModel.SortOptions.allCases) { option in
                                Text(option.rawValue.capitalized)
                                    .tag(option)
                            }
                        }
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                    }
                }
            }
            .task(priority: .high) { loadData(.initial) }
            .refreshable { loadData(.refresh) }
            .navigationTitle("Recipes")
        }
    }
}

// MARK: - PREVIEWS
#Preview("RecipesView - Mock Data") {
    RecipesView(recipeService: MockRecipeAPIService())
}

#Preview("RecipesView") {
    RecipesView(recipeService: RecipeAPIService())
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
    
    private func loadData(_ condition: FetchConditions) {
        switch condition {
        case .initial:
            recipeVM.sortedRecipesArray.isEmpty ? fetchData(endpoint: .all) : ()
            
        case .refresh:
            fetchData(endpoint: .all)
        }
    }
}
