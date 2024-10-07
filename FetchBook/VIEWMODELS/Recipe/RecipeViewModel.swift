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
    @Published var mutableRecipesArray: [RecipeModel] = []
    
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
    let recipeService: RecipeDataFetching
    
    /// The currently selected API endpoint for data retrieval.
    /// debug purposes only.
    @Published var selectedEndpoint: RecipeEndpointModel = RecipeEndpoints.all
    
    /// The current status of the data being processed, and fetched.
    @Published var currentDataStatus: RecipeDataStatusTypes = .fetching
    
    // MARK: - INITIALIZER
    /// Initializes a new instance of `RecipeViewModel` with the provided recipe service.
    ///
    /// - This initializer sets up the recipe fetching service used for retrieving recipe data.
    /// - It also subscribes to changes in the sorting option and search text to dynamically update the recipe list based on user input.
    ///
    /// - Parameter recipeService: A service conforming to `RecipeDataFetching` for fetching recipe data.
    init(recipeService: RecipeDataFetching) {
        self.recipeService = recipeService
        sortOptionSubscriber() // Subscribe to changes in the selected sorting option.
        recipeSearchTextSubscriber()
    }
    
    // MARK: - FUNCTIONS
    
    // MARK: - fetchRecipeData
    /// Fetches recipe data from the specified endpoint and updates the `recipesArray` and `mutableRecipesArray`.
    ///
    /// - The function sets the `currentDataStatus` to `.fetching` while waiting for the data.
    /// - Once the data is fetched, it updates the `recipesArray` and `mutableRecipesArray` with the fetched recipes.
    /// - If no recipes are returned, the `currentDataStatus` is set to `.emptyData`, otherwise it is set to `.none`.
    /// - If an error occurs during fetching, the `currentDataStatus` is updated to `.malformed`, and the error is thrown.
    ///
    /// - Parameter endpoint: The endpoint from which to fetch the recipe data.
    /// - Throws: An error if fetching data from the `RecipeService` fails.
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
                mutableRecipesArray = recipes // Initialize mutableRecipesArray with the fetched recipes.
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
    /// - Parameter option: The sorting option to apply (`az`, `za`, or `none`).
    /// - Returns: An array of `RecipeModel` sorted according to the specified option.
    ///   If the option is `.az`, the array is sorted in ascending order (A-Z),
    ///   if `.za`, it is sorted in descending order (Z-A), and if `.none`, the original array is returned.
    func sortRecipes(option: SortOptions) -> [RecipeModel] {
        switch option {
        case .az: recipesArray.sorted(by: { $0.name < $1.name }) // Sort A-Z.
        case .za: recipesArray.sorted(by: { $0.name > $1.name }) // Sort Z-A.
        case .none: recipesArray // Return unsorted array.
        }
    }
    
    // MARK: - sortOptionSubscriber
    /// Sets up a subscriber to observe changes in the selected sort option
    /// and updates the `mutableRecipesArray` accordingly.
    ///
    /// - This function listens for changes to the `selectedSortOption` property, which determines how the recipes should be sorted.
    /// - When the sort option is updated (e.g., A-Z, Z-A, or none), the function calls `sortRecipes(option:)` to sort the array based on the selected option.
    /// - Updates the `mutableRecipesArray` with the sorted results.
    /// - Stores the subscription in `cancelables` to ensure proper memory management and prevent memory leaks.
    func sortOptionSubscriber() {
        $selectedSortOption
            .sink { [weak self] option in
                guard let self else { return }
                mutableRecipesArray = sortRecipes(option: option) // Update mutableRecipesArray on option change.
            }
            .store(in: &cancelables) // Store the subscription in cancelables to manage memory.
    }
    
    // MARK: - recipeSearchTextSubscriber
    /// Subscribes to changes in the `recipeSearchText` property and updates the list of recipes accordingly.
    ///
    /// - This function listens for updates to the search text entered by the user.
    /// - When the search text is empty, all recipes are displayed and the `currentDataStatus` is set to `.none`.
    /// - When the search text contains valid input, the recipes are filtered based on the user's search using `filterSearchResult(_:)`.
    /// - Uses `debounce` to delay the filtering action until the user has stopped typing for 0.1 seconds, preventing unnecessary updates.
    /// - Updates `mutableRecipesArray` with either the full recipe list when no search text is entered or filtered results based on the search text.
    /// - Stores the subscription in `cancelables` to ensure proper memory management.
    func recipeSearchTextSubscriber() {
        $recipeSearchText
            .debounce(for: .seconds(0.1), scheduler: RunLoop.main)
            .sink { [weak self] text in
                guard let self else { return }
                
                if text.isEmpty {
                    currentDataStatus = .none
                    mutableRecipesArray = recipesArray
                } else {
                    filterSearchResult(text: text)
                }
            }
            .store(in: &cancelables)
    }
    
    // MARK: - filterSearchResult
    /// Filters the `mutableRecipesArray` based on the provided search text.
    ///
    /// - Converts the search text to lowercase to perform case-insensitive matching.
    /// - Filters the recipes by checking if the recipe's name or cuisine contains the search text.
    /// - Updates the `mutableRecipesArray` with the recipes that match the search criteria.
    /// - If the search text is empty, it resets `mutableRecipesArray` to the full `recipesArray`.
    /// - If no recipes match the search criteria, updates the `mutableRecipesArray` with an empty array.
    /// - Animates the update to `mutableRecipesArray` if matching recipes are found.
    /// - Updates the `currentDataStatus` to `.emptyResult` if no matches are found, or to `.none` otherwise.
    ///
    /// - Parameter text: The search text entered by the user to filter the recipe list.
    func filterSearchResult(text: String) {
        guard !text.isEmpty else {
            mutableRecipesArray = recipesArray
            return
        }
        
        let lowercasedText: String = text.lowercased()
        let filteredRecipesArray: [RecipeModel] = recipesArray.filter({
            $0.name.lowercased().contains(lowercasedText) ||
            $0.cuisine.lowercased().contains(lowercasedText)
        })
        
        if filteredRecipesArray.isEmpty {
            mutableRecipesArray = filteredRecipesArray
        } else {
            withAnimation {
                mutableRecipesArray = filteredRecipesArray
            }
        }
        
        currentDataStatus = mutableRecipesArray.isEmpty ? .emptyResult : .none
    }
}
