//
//  RecipesView.swift
//  FetchBook
//
//  Created by Mr. Kavinda Dilshan on 2024-10-05.
//

import SwiftUI

fileprivate enum FetchConditions {
    case initial, refresh
}

struct RecipesView: View {
    // MARK: - INITIAL PROPERTIES
    @ObservedObject private var recipeVM: RecipeViewModel
    
    // MARK: - INITIALIZER
    init(vm: RecipeViewModel) {
        _recipeVM = ObservedObject(wrappedValue: vm)
    }
    
    // MARK: - PRIVATE PROPERTIES
    @State private var blogPostItem: [BlogPostItemModel] = []
    let contentNotAvailableValues = ContentNotAvailableValues.self
    
    // MARK: - BODY
    var body: some View {
        NavigationStack(path: $blogPostItem) {
            Group {
                switch recipeVM.currentDataStatus {
                case .none:
                    successRecipeList
                    
                case .fetching:
                    shimmeringListEffect
                    
                case .malformed:
                    malformedError
                    
                case .emptyData:
                    emptyDataError
                    
                case .emptyResult:
                    emptySearchResults
                }
            }
            .searchable(text: recipeVM.recipeSearchTextBinding, prompt: "Search")
            .toolbar { ToolbarItem(placement: .automatic) {
                RecipeListSorterButtonView(vm: recipeVM) }
            }
            .navigationTitle("Recipes")
        }
        .refreshable {
            loadData(.refresh)
        }
        .task(priority: .high) {
            loadData(.initial)
        }
    }
}

// MARK: - PREVIEWS
#Preview("RecipesView - Mock") {
    RecipesView(vm: .init(recipeService: MockRecipeAPIService()))
}

// MARK: - EXTENSIONS
extension RecipesView {
    // MARK: - successRecipeList
    @ViewBuilder
    private var successRecipeList: some View {
        if let firstItem: RecipeModel = recipeVM.mutableRecipesArray.first,
           let lastItem: RecipeModel = recipeVM.mutableRecipesArray.last {
            List(recipeVM.mutableRecipesArray) { recipe in
                ListRowContentView(recipe: recipe, firstItemID: firstItem.id, lastItemID: lastItem.id)
                    .contextMenu {
                        RecipeImagePreviewContextMenuItemsView(
                            blogPostItem: $blogPostItem,
                            blogPostURLString: recipe.secureBlogPostURLString,
                            youtubeURLString: recipe.secureYoutubeURLString
                        )
                    } preview: {
                        RecipeImagePreviewView(recipe: recipe)
                    }
            }
            .listStyle(.plain)
            .navigationDestination(for: BlogPostItemModel.self) {
                RecipeBlogPostView(
                    secureBlogPostURLString: $0.secureBlogPostURLString,
                    secureYoutubeURLString: $0.secureYoutubeURLString,
                    showVideoPlayer: $0.showVideoPlayer
                )
            }
        }
    }
    
    // MARK: - shimmeringListEffect
    private var shimmeringListEffect: some View {
        RecipeShimmeringListView()
    }
    
    // MARK: - malformedError
    private var malformedError: some View {
        List {
            CustomContentNotAvailableView(contentNotAvailableValues.malformedRecipes)
                .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
    }
    
    // MARK: - emptyDataError
    private var emptyDataError: some View {
        List {
            CustomContentNotAvailableView(contentNotAvailableValues.emptyDataRecipes)
                .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
    }
    
    // MARK: - emptySearchResults
    private var emptySearchResults: some View {
        CustomContentNotAvailableView(contentNotAvailableValues.emptyRecipeSearchResults)
    }
    
    // MARK: FUNCTIONS
    
    // MARK: - fetchData
    /// Fetches recipe data from the specified endpoint.
    /// - Parameter endpoint: The endpoint model representing the recipe source.
    /// This function uses an asynchronous task to fetch the recipe data,
    /// updating the view model accordingly. If an error occurs during the fetch,
    /// it sets the current data status to .malformed and prints the error.
    private func fetchData(endpoint: RecipeEndpointTypes) {
        Task {
            do {
                try await recipeVM.fetchAndUpdateRecipes(endpoint: endpoint)
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - loadData
    /// Loads data based on the specified fetch condition.
    /// - Parameter condition: The condition that determines how data should be fetched.
    /// This function checks the condition and either fetches data for the first time
    /// (if the condition is .initial and the recipes array is empty) or refreshes the
    /// data (if the condition is .refresh) by calling fetchData with the selected endpoint.
    private func loadData(_ condition: FetchConditions) {
        switch condition {
        case .initial:
            recipeVM.recipesArray.isEmpty ? fetchData(endpoint: recipeVM.selectedEndpoint) : ()
            
        case .refresh:
            fetchData(endpoint: recipeVM.selectedEndpoint)
        }
    }
}
