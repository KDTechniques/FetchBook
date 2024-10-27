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
    }
    
    //MARK: - FUNCTIONS
    
    // MARK: - sortRecipes
    /// Sorts the `recipesArray` based on the specified sorting option.
    ///
    /// - Parameter option: The sorting option to apply. Can be one of the following:
    ///   - `.ascending`: Sorts the array in ascending order (A-Z) based on the `name` property of `RecipeModel`.
    ///   - `.descending`: Sorts the array in descending order (Z-A) based on the `name` property of `RecipeModel`.
    ///   - `.none`: Returns the array without any sorting (keeps the original order).
    ///
    /// - Returns: An array of `RecipeModel` sorted according to the specified option. If `.ascending` or `.descending` is selected, the recipes are sorted by their `name`. If `.none` is selected, the original order of `recipesArray` is retained.
    func sortRecipes(option: RecipeSortOptions) async -> [RecipeModel] {
        switch option {
        case .ascending: await recipeVM.recipesArray.sorted(by: { $0.name < $1.name }) // Sort A-Z.
        case .descending: await recipeVM.recipesArray.sorted(by: { $0.name > $1.name }) // Sort Z-A.
        case .none: await recipeVM.recipesArray // Return unsorted array.
        }
    }
    
    // MARK: - assignSortedRecipesToMutableRecipesArray
    /// Assigns sorted recipes to the `mutableRecipesArray`.
    ///
    /// This function sorts the recipes based on the specified sort option and assigns the sorted result to the `mutableRecipesArray`.
    /// If no sort option is provided, it defaults to the `selectedSortOption`.
    ///
    /// - Parameter option: An optional `RecipeSortOptions` value that determines the sorting criteria. If `nil`, the currently selected sort option will be used.
    /// - The function calls `sortRecipes(option:)` to sort the recipes and assigns the result to `mutableRecipesArray`.
    @MainActor
    func assignSortedRecipesToMutableRecipesArray(_ option: RecipeSortOptions? = nil) async {
        // Sort recipes using the provided option, or the default selectedSortOption if none is provided.
        await recipeVM.updateMutableRecipesArray(sortRecipes(option: option ?? recipeVM.selectedSortOption))
    }
    
    // MARK: - sortOptionSubscriber
    /// Sets up a subscriber to observe changes in the selected sort option
    /// and updates the `mutableRecipesArray` accordingly.
    ///
    /// - This function listens for changes to the `selectedSortOption` property, which determines how the recipes should be sorted.
    /// - When the sort option is updated (e.g., A-Z, Z-A, or none), the function calls `sortRecipes(option:)` to sort the array based on the selected option.
    /// - Updates the `mutableRecipesArray` with the sorted results.
    /// - Stores the subscription in `cancelables` to ensure proper memory management and prevent memory leaks.
    func sortOptionSubscriber() async {
        // Convert Combine publisher to async sequence
        // The for-await loop listens for new values from the publisher and processes them as they arrive.
        for await option in await sortOptionAsyncPublisher(for: recipeVM.$selectedSortOption) {
            // Ensure the UI updates are done on the main thread
            // Since `assignSortedRecipesToMutableRecipesArray(option:)` might modify the UI,
            // we use MainActor.run to guarantee it runs on the main thread.
            await assignSortedRecipesToMutableRecipesArray(option)
        }
    }
    
    // MARK: - sortOptionAsyncPublisher
    /// Converts a Combine publisher into an async sequence to be used with async-await syntax.
    ///
    /// - Takes a `Published<RecipeSortOptions>.Publisher` (i.e., a Combine publisher of `RecipeSortOptions`).
    /// - Yields values from the publisher as they arrive.
    /// - Properly handles cancellation when the async sequence terminates, ensuring no memory leaks.
    private func sortOptionAsyncPublisher(for publisher: Published<RecipeSortOptions>.Publisher) async -> AsyncStream<RecipeSortOptions> {
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
