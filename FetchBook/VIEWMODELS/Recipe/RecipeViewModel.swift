//
//  RecipeViewModel.swift
//  FetchBook
//
//  Created by Mr. Kavinda Dilshan on 2024-10-05.
//

import SwiftUI

/// A view model responsible for managing the recipe data, including fetching,
/// sorting, and publishing the sorted list of recipes to the SwiftUI view.
@MainActor
final class RecipeViewModel: ObservableObject {
    
    // MARK: - INITIAL PROPERTIES
    
    /// A service for fetching recipe data, adhering to the `RecipeServiceProtocol` protocol.
    private let recipeService: RecipeServiceProtocol
    private lazy var sortingManager: RecipeSortingManager = .init(recipeVM: self)
    private lazy var filteringManager: RecipeFilteringManager = .init(recipeVM: self, sortingManager: sortingManager)
    private lazy var dataManager: RecipeDataManager = .init(recipeVM: self, sortingManager: sortingManager, recipeService: recipeService)
    
    // MARK: - INITIALIZER
    /// Initializes a new instance of `RecipeViewModel` with the provided recipe service.
    ///
    /// - This initializer sets up the recipe fetching service used for retrieving recipe data.
    /// - It also subscribes to changes in the sorting option and search text to dynamically update the recipe list based on user input.
    ///
    /// - Parameter recipeService: A service conforming to `RecipeServiceProtocol` for fetching recipe data.
    init(recipeService: RecipeServiceProtocol) {
        self.recipeService = recipeService
        
        Task {
            await self.sortingManager.sortOptionSubscriber()
            await self.filteringManager.recipeSearchTextSubscriber()
        }
    }
    
    // MARK: - PRIVATE PROPERTIES
    
    /// An array holding the original recipe data fetched from the service.
    @Published private(set) var recipesArray: [RecipeModel] = []
    /// A published array that holds the sorted list of recipes, which updates the UI automatically.
    @Published private(set) var mutableRecipesArray: [RecipeModel] = []
    /// The current status of the data being processed, and fetched.
    @Published private(set) var currentDataStatus: RecipeDataStatusTypes = .fetching
    /// A string that holds the user's recipe search input.
    @Published private(set) var recipeSearchText: String = ""
    /// The selected sorting option for the recipes. Changes to this property will trigger
    /// the sorting of the recipes based on the chosen option.
    @Published private(set) var selectedSortOption: RecipeSortOptions = .none
    /// The currently selected API endpoint for data retrieval.
    /// debug purposes only.
    @Published private(set) var selectedEndpoint: RecipeEndpointModel = RecipeEndpointTypes.all.endpointModel
    
    // MARK: - PUBLIC PROPERTIES
    
    /// Public access to the `recipeSearchText` using a `Binding`
    var recipeSearchTextBinding: Binding<String> {
        return binding(\.recipeSearchText)
    }
    /// Public access to the `selectedSortOption` using a `Binding`
    var selectedSortOptionBinding: Binding<RecipeSortOptions> {
        return binding(\.selectedSortOption)
    }
    /// Public access to the `selectedEndpoint` using a `Binding`
    var selectedEndpointBinding: Binding<RecipeEndpointModel> {
        return binding(\.selectedEndpoint)
    }
    
    // MARK: - FUNCTIONS
    
    // MARK: - updateDataStatus
    /// Updates the current data status of the recipe view model.
    ///
    /// This method sets a new data status, which can be used to represent different states of data loading or processing.
    /// - Parameter newStatus: The new status to be set, of type `RecipeDataStatusTypes`.
    func updateDataStatus(_ newStatus: RecipeDataStatusTypes) {
        self.currentDataStatus = newStatus
    }
    
    // MARK: - updateMutableRecipesArray
    /// Updates the mutable recipes array with new data.
    ///
    /// This method sets a new array of recipes, which can be used to dynamically update the displayed recipes in the UI.
    /// - Parameter newArray: The new array of `RecipeModel` objects to be set.
    func updateMutableRecipesArray(_ newArray: [RecipeModel]) {
        self.mutableRecipesArray = newArray
    }
    
    // MARK: - updateRecipesArray
    /// Updates the main recipes array with new data.
    ///
    /// This method sets a new array of recipes, used to update the main collection of recipes in the view model.
    /// - Parameter newArray: The new array of `RecipeModel` objects to be set.
    func updateRecipesArray(_ newArray: [RecipeModel]) {
        self.recipesArray = newArray
    }
    
    // MARK: - fetchRecipeData
    /// Fetches recipe data from a specified endpoint asynchronously.
    ///
    /// This method performs a network request to fetch recipe data from a given endpoint and updates the view model accordingly.
    /// - Parameter endpoint: The endpoint from which to fetch recipe data, of type `RecipeEndpointModel`.
    /// - Throws: An error if the data fetching process fails.
    /// - Returns: A `RecipesModel` containing the fetched recipes.
    func fetchRecipeData(endpoint: RecipeEndpointModel) async throws {
        return try await dataManager.fetchRecipeData(endpoint: endpoint)
    }
}
