//
//  RecipeViewModel.swift
//  FetchBook
//
//  Created by Mr. Kavinda Dilshan on 2024-10-05.
//

import SwiftUI
import Combine

/// A view model responsible for managing the recipe data, including fetching,
/// sorting, and publishing the sorted list of recipes to the SwiftUI view.
final class RecipeViewModel: ObservableObject {
    
    /// An array holding the original recipe data fetched from the service.
    @Published private(set) var recipesArray: [RecipeModel] = []
    
    /// A published array that holds the sorted list of recipes, which updates the UI automatically.
    @Published var sortedRecipesArray: [RecipeModel] = []
    
    /// Enumeration representing sorting options available for the recipes.
    enum SortOptions: String, CaseIterable, Identifiable {
        case az = "A-Z"       // Sort recipes alphabetically from A to Z.
        case za = "Z-A"       // Sort recipes alphabetically from Z to A.
        case none             // No sorting applied.
        
        var id: String { self.rawValue } // Conforms to Identifiable for use in UI components.
    }
    
    /// The selected sorting option for the recipes. Changes to this property will trigger
    /// the sorting of the recipes based on the chosen option.
    @Published var selectedSortOption: SortOptions = .none
    
    /// A string that holds the user's recipe search input.
    @Published var recipeSearchText: String = ""
    
    /// A set to store cancellable subscriptions for Combine to manage memory and lifecycle of publishers.
    private var cancelables = Set<AnyCancellable>()
    
    /// A service for fetching recipe data, adhering to the `RecipeDataFetching` protocol.
    private let recipeService: RecipeDataFetching
    
    /// The currently selected API endpoint for data retrieval.
    /// debug purposes only.
    @Published var selectedEndpoint: RecipeEndpointModel = RecipeEndpoints.all
    
    /// The current status of the data being processed, and fetched.
    @Published var currentDataStatus: RecipeDataStatusTypes = .fetching
    
    // MARK: - INITIALIZER
    /// Initializes a new instance of `RecipeViewModel` with the provided recipe service.
    ///
    /// - Parameter recipeService: A service conforming to `RecipeDataFetching` for fetching recipe data.
    init(recipeService: RecipeDataFetching) {
        self.recipeService = recipeService
        sortOptionSubscriber() // Subscribe to changes in the selected sorting option.
        recipeSearchTextSubscriber()
    }
    
    // MARK: - FUNCTIONS
    
    /// Fetches recipe data from the specified endpoint and updates the recipes array and sorted recipes array.
    ///
    /// - Parameter endpoint: The endpoint from which to fetch recipe data.
    /// - Throws: An error if the fetching fails.
    func fetchRecipeData(endpoint: RecipeEndpointModel) async throws {
        do {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                currentDataStatus = .fetching
            }
            
            let recipesResponse = try await recipeService.fetchRecipeData(from: endpoint)
            let recipes: [RecipeModel] = recipesResponse.recipes
            
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                
                currentDataStatus = recipes.isEmpty ? .emptyData : .none
                recipesArray = recipes // Store fetched recipes in recipesArray.
                sortedRecipesArray = recipes // Initialize sortedRecipesArray with the fetched recipes.
            }
        } catch {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                currentDataStatus = .malformed
            }
            
            throw error
        }
    }
    
    // MARK: - sortRecipes
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
    
    // MARK: - sortOptionSubscriber
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
    
    // MARK: - recipeSearchTextSubscriber
    /// Subscribes to changes in the `recipeSearchText` property and updates the list of recipes accordingly.
    ///
    /// - This function listens for updates to the search text entered by the user.
    /// - When the search text is empty, all recipes are displayed.
    /// - When the search text contains valid input, the recipes are filtered based on the user's search.
    /// - Uses `debounce` to delay the filtering action until the user has stopped typing for a specified duration.
    /// - Updates `sortedRecipesArray` with either the full recipe list or filtered results.
    private func recipeSearchTextSubscriber() {
        $recipeSearchText
            .debounce(for: .seconds(0.1), scheduler: RunLoop.main)
            .sink { [weak self] text in
                guard let self else { return }
                text.isEmpty ? sortedRecipesArray = recipesArray : filterSearchResult(text: text)
            }
            .store(in: &cancelables)
    }
    
    // MARK: - filterSearchResult
    /// Filters the `sortedRecipesArray` based on the provided search text.
    ///
    /// - Converts the search text to lowercase to perform case-insensitive matching.
    /// - Filters the recipes by checking if the recipe's name or cuisine contains the search text.
    /// - Updates the `sortedRecipesArray` with the recipes that match the search criteria.
    ///
    /// - Parameter text: The search text entered by the user to filter the recipe list.
    private func filterSearchResult(text: String) {
        let lowercasedText: String = text.lowercased()
        let filteredRecipesArray: [RecipeModel] = recipesArray.filter({
            $0.name.lowercased().contains(lowercasedText) ||
            $0.cuisine.lowercased().contains(lowercasedText)
        })
        
        if filteredRecipesArray.isEmpty {
            sortedRecipesArray = filteredRecipesArray
        } else {
            withAnimation {
                sortedRecipesArray = filteredRecipesArray
            }
        }
        
        currentDataStatus = sortedRecipesArray.isEmpty ? .emptyResult : .none
    }
}
