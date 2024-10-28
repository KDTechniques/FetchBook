//
//  RecipeDataManager.swift
//  FetchBook
//
//  Created by Mr. Kavinda Dilshan on 2024-10-20.
//

import Foundation

actor RecipeDataManager {
    // MARK: - PROPERTIES
    private let recipeVM: RecipeViewModel
    private let sortingManager: RecipeSortingManager
    private let recipeService: RecipeServiceProtocol
    
    // MARK: - INITIALIZER
    init(recipeVM: RecipeViewModel, sortingManager: RecipeSortingManager, recipeService: RecipeServiceProtocol) {
        self.recipeVM = recipeVM
        self.sortingManager = sortingManager
        self.recipeService = recipeService
    }
    
    // MARK: FUNCTIONS
    
    // MARK: - fetchRecipeData
    /// Fetches recipe data from the specified endpoint and updates the `recipesArray` and `mutableRecipesArray`.
    ///
    /// - The function sets the `currentDataStatus` to `.fetching` while waiting for the data.
    /// - Once the data is fetched, it updates the `recipesArray` and `mutableRecipesArray` with the fetched recipes.
    /// - If no recipes are returned, the `currentDataStatus` is set to `.emptyData`, otherwise it is set to `.none`.
    /// - If an error occurs during fetching, the `currentDataStatus` is updated to `.malformed`,
    /// empty both `recipesArray` and `mutableRecipesArray` then the error is thrown.
    ///
    /// - Parameter endpoint: The endpoint from which to fetch the recipe data.
    /// - Throws: An error if fetching data from the `RecipeService` fails.
    func fetchRecipeData(endpoint: RecipeEndpointModel) async throws {
        await recipeVM.updateDataStatus(.fetching)
        do {
            let recipesResponse = try await recipeService.fetchRecipeData(from: endpoint)
            let recipes: [RecipeModel] = recipesResponse.recipes
            await recipeVM.updateDataStatus(recipes.isEmpty ? .emptyData : .none)
            
            // Store fetched recipes in recipesArray.
            await recipeVM.updateRecipesArray(recipes)
            
            // Initialize mutableRecipesArray with the fetched and sorted recipes.
            await sortingManager.assignSortedRecipesToMutableRecipesArray()
        } catch {
            await recipeVM.updateDataStatus(.malformed)
            await recipeVM.updateRecipesArray([])
            await recipeVM.updateMutableRecipesArray([])
            throw error
        }
    }
}
