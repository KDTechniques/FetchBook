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
    
    // MARK: - PROPERTIES
    
    /// A service for fetching recipe data, adhering to the `RecipeDataFetching` protocol.
    private let recipeService: RecipeDataFetching
    private lazy var sortingManager: RecipeSortingManager = .init(recipeVM: self)
    private lazy var filteringManager: RecipeFilteringManager = .init(recipeVM: self, sortingManager: sortingManager)
    private lazy var dataManager: RecipeDataManager = .init(
        recipeVM: self,
        sortingManager: sortingManager,
        recipeService: recipeService
    )
    
    // MARK: - INITIALIZER
    /// Initializes a new instance of `RecipeViewModel` with the provided recipe service.
    ///
    /// - This initializer sets up the recipe fetching service used for retrieving recipe data.
    /// - It also subscribes to changes in the sorting option and search text to dynamically update the recipe list based on user input.
    ///
    /// - Parameter recipeService: A service conforming to `RecipeDataFetching` for fetching recipe data.
    init(recipeService: RecipeDataFetching) {
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
    
    // Public access to the `recipeSearchText` using a `Binding`
    var recipeSearchTextBinding: Binding<String> { binding(\.recipeSearchText) }
    
    // Public access to the `selectedSortOption` using a `Binding`
    var selectedSortOptionBinding: Binding<RecipeSortOptions> { binding(\.selectedSortOption) }
    
    // Public access to the `selectedEndpoint` using a `Binding`
    var selectedEndpointBinding: Binding<RecipeEndpointModel> { binding(\.selectedEndpoint) }
    
    // MARK: - FUNCTIONS
    
    // MARK: - updateDataStatus
    /// Public method to update the current data status.
    func updateDataStatus(_ newStatus: RecipeDataStatusTypes) {
        self.currentDataStatus = newStatus
    }
    
    // MARK: - updateMutableRecipesArray
    func updateMutableRecipesArray(_ newArray: [RecipeModel]) {
        self.mutableRecipesArray = newArray
    }
    
    // MARK: - updateRecipesArray
    func updateRecipesArray(_ newArray: [RecipeModel]) {
        self.recipesArray = newArray
    }
    
    // MARK: - fetchRecipeData
    func fetchRecipeData(endpoint: RecipeEndpointModel) async throws {
        try await dataManager.fetchRecipeData(endpoint: endpoint)
    }
}
