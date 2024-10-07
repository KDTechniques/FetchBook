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
    @ObservedObject private var recipeVM: RecipeViewModel
    
    // MARK: - PRIVATE PROPERTIES
    @State private var isLoading: Bool = true
    
    enum FetchConditions { case initial, refresh }
    
    // MARK: - INITIALIZER
    init(vm: RecipeViewModel) {
        _recipeVM = ObservedObject(wrappedValue: vm)
    }
    
    // MARK: - BODY
    var body: some View {
        NavigationStack {
            Group {
                switch recipeVM.currentDataStatus {
                case .none: successRecipeList
                case .fetching: shimmeringListEffect
                case .malformed: malformedError
                case .emptyData: emptyDataError
                case .emptyResult: emptySearchResults
                    
                }
            }
            .toolbar { ToolbarItem(placement: .automatic) { RecipeListSorterButtonView(vm: recipeVM) } }
            .task(priority: .high) { loadData(.initial) }
            .refreshable { loadData(.refresh) }
            .navigationTitle("Recipes")
        }
        .searchable(text: $recipeVM.recipeSearchText, prompt: "Search")
    }
}

// MARK: - PREVIEWS
#Preview("RecipesView - Mock") {
    RecipesView(vm: .init(recipeService: MockRecipeAPIService()))
}

#Preview("RecipesView") {
    RecipesView(vm: .init(recipeService: RecipeAPIService()))
}

// MARK: - EXTENSIONS
extension RecipesView {
    // MARK: - successRecipeList
    private var successRecipeList: some View {
        List(recipeVM.sortedRecipesArray) { ListRowContentView(recipe: $0) }
    }
    
    // MARK: - shimmeringListEffect
    private var shimmeringListEffect: some View {
        RecipeShimmeringListView()
    }
    
    // MARK: - malformedError
    private var malformedError: some View {
        List {
            CustomContentNotAvailableView(.init(
                systemImageName: "exclamationmark.icloud",
                title: "No Recipes",
                description: "We're having trouble loading the recipes right now. Please try again later."
            ))
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
    }
    
    // MARK: - emptyDataError
    private var emptyDataError: some View {
        List {
            CustomContentNotAvailableView(.init(
                systemImageName: "fork.knife",
                title: "No Recipes",
                description: "Recipes are currently unavailable from our end. Please check back later."
            ))
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
    }
    
    // MARK: - emptySearchResults
    private var emptySearchResults: some View {
        CustomContentNotAvailableView(.init(title: "No Results"))
    }
    
    // MARK: - fetchData
    /// Fetches recipe data from the specified endpoint.
    /// - Parameter endpoint: The endpoint model representing the recipe source.
    /// This function uses an asynchronous task to fetch the recipe data,
    /// updating the view model accordingly. If an error occurs during the fetch,
    /// it sets the current data status to .malformed and prints the error.
    private func fetchData(endpoint: RecipeEndpointModel) {
        Task {
            do {
                try await recipeVM.fetchRecipeData(endpoint: endpoint)
            } catch {
                print("Error fetching recipes: \(error)")
                recipeVM.currentDataStatus = .malformed
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
