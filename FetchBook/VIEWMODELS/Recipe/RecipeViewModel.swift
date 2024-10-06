//
//  RecipeViewModel.swift
//  FetchBook
//
//  Created by Mr. Kavinda Dilshan on 2024-10-05.
//

import Foundation
import Combine

/// A view model responsible for managing the recipe data, including fetching,
/// sorting, and publishing the sorted list of recipes to the SwiftUI view.
final class RecipeViewModel: ObservableObject {
    
    /// An array holding the original recipe data fetched from the service.
    private var recipesArray: [RecipeModel] = []
    
    /// A published array that holds the sorted list of recipes, which updates the UI automatically.
    @Published var sortedRecipesArray: [RecipeModel] = []
    
    /// The selected sorting option for the recipes. Changes to this property will trigger
    /// the sorting of the recipes based on the chosen option.
    @Published var selectedSortOption: SortOptions = .none
    
    /// A set to store cancellable subscriptions for Combine to manage memory and lifecycle of publishers.
    private var cancelables = Set<AnyCancellable>()
    
    /// A service for fetching recipe data, adhering to the `RecipeDataFetching` protocol.
    private let recipeService: RecipeDataFetching
    
    /// Enumeration representing sorting options available for the recipes.
    enum SortOptions: String, CaseIterable, Identifiable {
        case az = "A-Z"       // Sort recipes alphabetically from A to Z.
        case za = "Z-A"       // Sort recipes alphabetically from Z to A.
        case none             // No sorting applied.
        
        var id: String { self.rawValue } // Conforms to Identifiable for use in UI components.
    }
    
    /// Enumeration representing the different API endpoints for fetching recipes.
    enum Endpoints: String {
        case all = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json" // Endpoint for all recipes.
        case malformed = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json" // Endpoint for malformed data.
        case empty = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json" // Endpoint for empty data.
    }
    
    // MARK: - INITIALIZER
    
    /// Initializes a new instance of `RecipeViewModel` with the provided recipe service.
    ///
    /// - Parameter recipeService: A service conforming to `RecipeDataFetching` for fetching recipe data.
    init(recipeService: RecipeDataFetching) {
        self.recipeService = recipeService
        sortOptionSubscriber() // Subscribe to changes in the selected sorting option.
    }
    
    // MARK: - FUNCTIONS
    
    /// Fetches recipe data from the specified endpoint and updates the recipes array and sorted recipes array.
    ///
    /// - Parameter endpoint: The endpoint from which to fetch recipe data.
    /// - Throws: An error if the fetching fails.
    func fetchRecipeData(endpoint: Endpoints) async throws {
        let recipesResponse = try await recipeService.fetchRecipeData(from: endpoint)
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.recipesArray = recipesResponse.recipes // Store fetched recipes in recipesArray.
            self.sortedRecipesArray = self.recipesArray // Initialize sortedRecipesArray with the fetched recipes.
        }
    }
    
    /// Sorts the recipes based on the selected sorting option.
    ///
    /// - Parameter option: The sorting option to apply.
    /// - Returns: An array of `RecipeModel` sorted according to the specified option.
    private func sortRecipes(option: SortOptions) -> [RecipeModel] {
        switch option {
        case .az: return recipesArray.sorted(by: { $0.name < $1.name }) // Sort A-Z.
        case .za: return recipesArray.sorted(by: { $0.name > $1.name }) // Sort Z-A.
        case .none: return recipesArray // Return unsorted array.
        }
    }
    
    /// Sets up a subscriber to observe changes in the selected sort option
    /// and updates the sorted recipes array accordingly.
    private func sortOptionSubscriber() {
        $selectedSortOption
            .sink { [weak self] option in
                guard let self else { return }
                self.sortedRecipesArray = self.sortRecipes(option: option) // Update sortedRecipesArray on option change.
            }
            .store(in: &cancelables) // Store the subscription in cancelables to manage memory.
    }
}
