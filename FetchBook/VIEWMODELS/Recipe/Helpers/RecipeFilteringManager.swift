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
    }
    
    // MARK: - FUNCTIONS
    
    // MARK: - createDebouncedTextStream
    /// Creates a debounced async stream from the `recipeSearchText` publisher.
    ///
    /// This function converts the `recipeSearchText` Combine publisher into an `AsyncStream` so that it can be consumed with async/await. It yields new search text whenever it is updated.
    ///
    /// - Returns: An `AsyncStream<String>` that emits the latest value of `recipeSearchText` each time it is updated.
    @MainActor
    private func createDebouncedTextStream() async -> AsyncStream<String> {
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
    
    // MARK: - handleDebouncedSearchText
    /// Handles the debounced search text logic, performing a search or resetting recipes depending on the text.
    ///
    /// This function checks if the text has changed long enough to trigger a search or reset. If the text is empty, it resets the recipes with the current sorting option. Otherwise, it calls the filtering method.
    ///
    /// - Parameters:
    ///   - text: The latest text from the search field.
    ///   - lastSearchTime: A reference to the last time the search was triggered. This will be updated based on the debounce logic.
    ///   - debounceDelay: The time delay (in seconds) between search queries, used to debounce rapid text changes.
    private func handleDebouncedSearchText(_ text: String, lastSearchTime: inout Date, debounceDelay: TimeInterval) async {
        let timeElapsed = Date().timeIntervalSince(lastSearchTime)
        
        // If enough time has passed since the last search, perform the necessary action
        if timeElapsed > debounceDelay {
            lastSearchTime = Date() // Update the last search time
            
            // If the search text is empty, reset data and update recipes
            if text.isEmpty {
                await resetRecipes()
            } else {
                // Otherwise, perform the filtering logic asynchronously
                await filterSearchResult(text: text)
            }
        } else {
            // If debounce delay hasn't passed, sleep for the remaining time before checking again
            let sleepTime = debounceDelay - timeElapsed
            try? await Task.sleep(nanoseconds: UInt64(sleepTime * 1_000_000_000)) // Sleep for the remaining time in nanoseconds
        }
    }
    
    // MARK: - recipeSearchTextSubscriber
    /// Main function to subscribe to recipe search text updates and handle them asynchronously with debounce.
    ///
    /// This function listens for updates to `recipeSearchText`, applies debouncing logic, and then triggers either a reset of recipes or filtering of search results based on the text. The logic ensures that searches are only triggered after the user has stopped typing for a defined period of time (debounce).
    func recipeSearchTextSubscriber() async {
        Task {
            var lastSearchTime = Date()
            let debounceDelay: TimeInterval = 0.1 // Define the debounce delay (0.1 seconds)
            
            // Create the debounced text stream to consume the latest recipe search text
            let debouncedTextStream = await createDebouncedTextStream()
            
            // Iterate over the debounced text stream
            for await text in debouncedTextStream {
                // Handle the debounced search text asynchronously
                await handleDebouncedSearchText(text, lastSearchTime: &lastSearchTime, debounceDelay: debounceDelay)
            }
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
        await sortingManager.assignSortedRecipesToMutableRecipesArray() // Reset recipes with the current sorting
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
            await sortingManager.assignSortedRecipesToMutableRecipesArray()
            return
        }
        
        let lowercasedText: String = text.lowercased()
        let sortedRecipesArray: [RecipeModel] = await sortingManager.sortRecipes(option: recipeVM.selectedSortOption)
        let filteredRecipesArray: [RecipeModel] = sortedRecipesArray.filter({
            $0.name.lowercased().contains(lowercasedText) ||
            $0.cuisine.lowercased().contains(lowercasedText)
        })
        
        if filteredRecipesArray.isEmpty {
            recipeVM.updateMutableRecipesArray(filteredRecipesArray)
        } else {
            withAnimation {
                recipeVM.updateMutableRecipesArray(filteredRecipesArray)
            }
        }
        
        recipeVM.updateDataStatus(recipeVM.mutableRecipesArray.isEmpty ? .emptyResult : .none)
    }
}
