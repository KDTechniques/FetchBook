//
//  RecipeFilteringManager.swift
//  FetchBook
//
//  Created by Mr. Kavinda Dilshan on 2024-10-20.
//

import SwiftUI

actor RecipeFilteringManager {
    // MARK: - PROPERTIES
    private let recipeVM: RecipeViewModel
    private let sortingManager: RecipeSortingManager
    
    //  MARK: - INITIALIZER
    init(recipeVM: RecipeViewModel, sortingManager: RecipeSortingManager) {
        self.recipeVM = recipeVM
        self.sortingManager = sortingManager
        Task { await self.recipeSearchTextSubscriber() }
    }
    
    // MARK: FUNCTIONS
    
    // MARK: - createDebouncedTextStream
    /// Creates an async stream from the `recipeSearchText` publisher.
    ///
    /// This function converts the `recipeSearchText` Combine publisher into an `AsyncStream` so that it can be consumed with async/await. It yields new search text whenever it is updated.
    ///
    /// - Returns: An `AsyncStream<String>` that emits the latest value of `recipeSearchText` each time it is updated.
    @MainActor
    private func createTextStream() async -> AsyncStream<String> {
        AsyncStream { continuation in
            // Subscribe to the `recipeSearchText` publisher
            let subscription = recipeVM.$recipeSearchText
                .dropFirst()
                .sink { text in
                    continuation.yield(text) // Yield the new text value to the async stream
                }
            
            // Cancel the subscription when the async stream is terminated
            continuation.onTermination = { _ in
                subscription.cancel()
            }
        }
    }
    
    // MARK: - recipeSearchTextSubscriber
    /// Main function to subscribe to recipe search text updates and handle them asynchronously.
    ///
    /// This function listens for updates to `recipeSearchText`, and  triggers filtering of search results based on the text.
    private func recipeSearchTextSubscriber() async {
        // Create the text stream to consume the latest recipe search text
        let textStream = await createTextStream()
        
        // Iterate over the debounced text stream
        for await text in textStream {
            // Handle the debounced search text asynchronously
            await filterSearchResult(text: text)
        }
    }
    
    // MARK: - resetRecipes
    /// Resets the recipes and sets the current data status to `.none` when the search text is empty.
    ///
    /// This function is called when the search text is cleared, to reset the data state and update the recipe list according to the current sorting option.
    ///
    /// This operation runs on the main actor to update the UI-related state.
    private func resetRecipes() async {
        await recipeVM.updateDataStatus(.none)
        // Reset recipes with the current sorting
        await sortingManager.assignSortedRecipesToMutableRecipesArray()
    }
    
    // MARK: - filterSearchResult
    /// Filters the `mutableRecipesArray` based on the provided search text.
    ///
    /// - Converts the search text to lowercase to enable case-insensitive matching.
    /// - Filters the recipes by checking if the recipe's name or cuisine contains the search text.
    /// - Updates the `mutableRecipesArray` with the recipes that match the search criteria.
    /// - If the search text is empty, it resets `mutableRecipesArray` to the full `recipesArray`.
    /// - If no recipes match the search criteria, updates the `mutableRecipesArray` with an empty array.
    /// - Animates the update to `mutableRecipesArray` if matching recipes are found.
    /// - Updates the `currentDataStatus` to `.emptyResult` if no matches are found, or to `.none` otherwise.
    ///
    /// - Parameter text: The search text entered by the user to filter the recipe list.
    @MainActor
    private func filterSearchResult(text: String) async {
        guard !text.isEmpty else {
            await resetRecipes()
            return
        }
        let lowercasedText: String = text.lowercased()
        let sortedRecipesArray: [RecipeModel] = await sortingManager.sortRecipes(type: recipeVM.selectedSortType)
        let filteredRecipesArray: [RecipeModel] = sortedRecipesArray.filter({
            $0.name.lowercased().contains(lowercasedText) ||
            $0.cuisine.lowercased().contains(lowercasedText)
        })
        if filteredRecipesArray.isEmpty {
            recipeVM.updateMutableRecipesArray([])
        } else {
            withAnimation {
                recipeVM.updateMutableRecipesArray(filteredRecipesArray)
            }
        }
        recipeVM.updateDataStatus(recipeVM.mutableRecipesArray.isEmpty ? .emptyResult : .none)
    }
}
