//
//  RecipeSortingManager.swift
//  FetchBook
//
//  Created by Mr. Kavinda Dilshan on 2024-10-20.
//

import Foundation

actor RecipeSortingManager {
    // MARK: - PROPERTIES
    let recipeVM: RecipeViewModel
    
    // MARK: - INITIALIZER
    init(recipeVM: RecipeViewModel) {
        self.recipeVM = recipeVM
        Task { await self.sortOptionSubscriber() }
    }
    
    // MARK: FUNCTIONS
    
    // MARK: - sortRecipes
    /// Sorts the `recipesArray` based on the specified sorting option.
    ///
    /// - Parameter type: The sorting option to apply. Can be one of the following:
    ///   - `.ascending`: Sorts the array in ascending order (A-Z) based on the `name` property of `RecipeModel`.
    ///   - `.descending`: Sorts the array in descending order (Z-A) based on the `name` property of `RecipeModel`.
    ///   - `.none`: Returns the array without any sorting (keeps the original order).
    ///
    /// - Returns: An array of `RecipeModel` sorted according to the specified option. If `.ascending` or `.descending` is selected, the recipes are sorted by their `name`. If `.none` is selected, the original order of `recipesArray` is retained.
    func sortRecipes(type: RecipeSortTypes) async -> [RecipeModel] {
        switch type {
        case .ascending: await recipeVM.recipesArray.sorted(by: { $0.name < $1.name }) // Sort A-Z.
        case .descending: await recipeVM.recipesArray.sorted(by: { $0.name > $1.name }) // Sort Z-A.
        case .none: await recipeVM.recipesArray // Return unsorted array.
        }
    }
    
    // MARK: - assignSortedRecipesToMutableRecipesArray
    /// Assigns sorted recipes to the `mutableRecipesArray`.
    ///
    /// This function sorts the recipes based on the specified sort option and assigns the sorted result to the `mutableRecipesArray`.
    /// If no sort option is provided, it defaults to the `selectedSortType`.
    ///
    /// - Parameter type: An optional `RecipeSortTypes` value that determines the sorting criteria. If `nil`, the currently selected sort option will be used.
    /// - The function calls `sortRecipes(type:)` to sort the recipes and assigns the result to `mutableRecipesArray`.
    @MainActor
    func assignSortedRecipesToMutableRecipesArray(_ type: RecipeSortTypes? = nil) async {
        // Sort recipes using the provided option, or the default selectedSortType if none is provided.
        let sortedRecipesArray: [RecipeModel] = await sortRecipes(type: type ?? recipeVM.selectedSortType)
        recipeVM.updateMutableRecipesArray(sortedRecipesArray)
    }
    
    // MARK: - sortOptionSubscriber
    /// Sets up a subscriber to observe changes in the selected sort option
    /// and updates the `mutableRecipesArray` accordingly.
    ///
    /// - This function listens for changes to the `selectedSortType` property, which determines how the recipes should be sorted.
    /// - When the sort option is updated (e.g., A-Z, Z-A, or none), the function calls `sortRecipes(type:)` to sort the array based on the selected option.
    /// - Updates the `mutableRecipesArray` with the sorted results.
    /// - Stores the subscription in `cancelables` to ensure proper memory management and prevent memory leaks.
    private func sortOptionSubscriber() async {
        // Convert Combine publisher to async sequence
        // The for-await loop listens for new values from the publisher and processes them as they arrive.
        for await option in await sortOptionAsyncPublisher(for: recipeVM.$selectedSortType) {
            // Ensure the UI updates are done on the main thread
            // Since `assignSortedRecipesToMutableRecipesArray(type:)` might modify the UI,
            // we use MainActor.run to guarantee it runs on the main thread.
            await assignSortedRecipesToMutableRecipesArray(option)
        }
    }
    
    // MARK: - sortOptionAsyncPublisher
    /// Converts a Combine publisher into an async sequence to be used with async-await syntax.
    ///
    /// - Takes a `Published<RecipeSortTypes>.Publisher` (i.e., a Combine publisher of `RecipeSortTypes`).
    /// - Yields values from the publisher as they arrive.
    /// - Properly handles cancellation when the async sequence terminates, ensuring no memory leaks.
    private func sortOptionAsyncPublisher(for publisher: Published<RecipeSortTypes>.Publisher) async -> AsyncStream<RecipeSortTypes> {
        AsyncStream { continuation in
            // Create a cancellable to handle the subscription to the publisher.
            let cancellable = publisher
                .dropFirst()
                .sink { option in
                    // When a new value is received, yield it into the async sequence.
                    continuation.yield(option)
                }
            
            // Proper cancellation when the stream terminates
            // This ensures that when the async sequence is cancelled, the Combine subscription is also cancelled,
            // preventing memory leaks and unnecessary background work.
            continuation.onTermination = { _ in
                cancellable.cancel()
            }
        }
    }
}
