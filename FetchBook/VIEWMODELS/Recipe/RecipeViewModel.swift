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
    
    /// An array holding the original recipe data fetched from the service.
    @Published private(set) var recipesArray: [RecipeModel] = []
    
    /// A published array that holds the sorted list of recipes, which updates the UI automatically.
    @Published var mutableRecipesArray: [RecipeModel] = []
    
    /// Enumeration representing sorting options available for the recipes.
    enum SortOptions: String, CaseIterable, Identifiable {
        case ascending = "Ascending"// Sort recipes alphabetically from A to Z.
        case descending = "descending" // Sort recipes alphabetically from Z to A.
        case none = "default" // No sorting applied.
        
        var id: String { self.rawValue } // Conforms to Identifiable for use in UI components.
    }
    
    /// The selected sorting option for the recipes. Changes to this property will trigger
    /// the sorting of the recipes based on the chosen option.
    @Published var selectedSortOption: SortOptions = .none
    
    /// A string that holds the user's recipe search input.
    @Published var recipeSearchText: String = ""
    
    /// A service for fetching recipe data, adhering to the `RecipeDataFetching` protocol.
    let recipeService: RecipeDataFetching
    
    /// The currently selected API endpoint for data retrieval.
    /// debug purposes only.
    @Published var selectedEndpoint: RecipeEndpointModel = RecipeEndpointTypes.all.endpointModel
    
    /// The current status of the data being processed, and fetched.
    @Published var currentDataStatus: RecipeDataStatusTypes = .none
    
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
        await MainActor.run { currentDataStatus = .fetching }
        
        do {
            let recipesResponse = try await recipeService.fetchRecipeData(from: endpoint)
            let recipes: [RecipeModel] = recipesResponse.recipes
            
            await MainActor.run {
                currentDataStatus = recipes.isEmpty ? .emptyData : .none
                recipesArray = recipes // Store fetched recipes in recipesArray.
                assignSortedRecipesToMutableRecipesArray() // Initialize mutableRecipesArray with the fetched and sorted recipes.
            }
        } catch {
            await MainActor.run { currentDataStatus = .malformed }
            throw error
        }
    }
    
    // MARK: - assignSortedRecipesToMutableRecipesArray
    /// Assigns sorted recipes to the `mutableRecipesArray`.
    ///
    /// This function sorts the recipes based on the specified sort option and assigns the sorted result to the `mutableRecipesArray`.
    /// If no sort option is provided, it defaults to the `selectedSortOption`.
    ///
    /// - Parameter option: An optional `SortOptions` value that determines the sorting criteria. If `nil`, the currently selected sort option will be used.
    /// - The function calls `sortRecipes(option:)` to sort the recipes and assigns the result to `mutableRecipesArray`.
    private func assignSortedRecipesToMutableRecipesArray(_ option: SortOptions? = nil) {
        // Sort recipes using the provided option, or the default selectedSortOption if none is provided.
        mutableRecipesArray = sortRecipes(option: option ?? selectedSortOption)
    }
    
    // MARK: - sortRecipes
    /// Sorts the `recipesArray` based on the specified sorting option.
    ///
    /// - Parameter option: The sorting option to apply. Can be one of the following:
    ///   - `.ascending`: Sorts the array in ascending order (A-Z) based on the `name` property of `RecipeModel`.
    ///   - `.descending`: Sorts the array in descending order (Z-A) based on the `name` property of `RecipeModel`.
    ///   - `.none`: Returns the array without any sorting (keeps the original order).
    ///
    /// - Returns: An array of `RecipeModel` sorted according to the specified option. If `.ascending` or `.descending` is selected, the recipes are sorted by their `name`. If `.none` is selected, the original order of `recipesArray` is retained.
    func sortRecipes(option: SortOptions) -> [RecipeModel] {
        switch option {
        case .ascending: return recipesArray.sorted(by: { $0.name < $1.name }) // Sort A-Z.
        case .descending: return recipesArray.sorted(by: { $0.name > $1.name }) // Sort Z-A.
        case .none: return recipesArray // Return unsorted array.
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
    private func sortOptionSubscriber() {
        Task {
            // Convert Combine publisher to async sequence
            // The for-await loop listens for new values from the publisher and processes them as they arrive.
            for await option in sortOptionAsyncPublisher(for: $selectedSortOption) {
                // Ensure the UI updates are done on the main thread
                // Since `assignSortedRecipesToMutableRecipesArray(option:)` might modify the UI,
                // we use MainActor.run to guarantee it runs on the main thread.
                await MainActor.run {
                    assignSortedRecipesToMutableRecipesArray(option)
                }
            }
        }
    }
    
    // MARK: - sortOptionAsyncPublisher
    /// Converts a Combine publisher into an async sequence to be used with async-await syntax.
    ///
    /// - Takes a `Published<SortOptions>.Publisher` (i.e., a Combine publisher of `SortOptions`).
    /// - Yields values from the publisher as they arrive.
    /// - Properly handles cancellation when the async sequence terminates, ensuring no memory leaks.
    private func sortOptionAsyncPublisher(for publisher: Published<SortOptions>.Publisher) -> AsyncStream<SortOptions> {
        AsyncStream { continuation in
            // Create a cancellable to handle the subscription to the publisher.
            let cancellable = publisher.sink { option in
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
    
    // MARK: - createDebouncedTextStream
    /// Creates a debounced async stream from the `recipeSearchText` publisher.
    ///
    /// This function converts the `recipeSearchText` Combine publisher into an `AsyncStream` so that it can be consumed with async/await. It yields new search text whenever it is updated.
    ///
    /// - Returns: An `AsyncStream<String>` that emits the latest value of `recipeSearchText` each time it is updated.
    private func createDebouncedTextStream() -> AsyncStream<String> {
        return AsyncStream { continuation in
            // Subscribe to the `recipeSearchText` publisher
            let subscription = $recipeSearchText
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
                resetRecipes()
            } else {
                // Otherwise, perform the filtering logic asynchronously
                filterSearchResult(text: text)
            }
        } else {
            // If debounce delay hasn't passed, sleep for the remaining time before checking again
            let sleepTime = debounceDelay - timeElapsed
            try? await Task.sleep(nanoseconds: UInt64(sleepTime * 1_000_000_000)) // Sleep for the remaining time in nanoseconds
        }
    }
    
    // MARK: - resetRecipes
    /// Resets the recipes and sets the current data status to `.none` when the search text is empty.
    ///
    /// This function is called when the search text is cleared, to reset the data state and update the recipe list according to the current sorting option.
    ///
    /// This operation runs on the main actor to update the UI-related state.
    private func resetRecipes() {
        currentDataStatus = .none
        assignSortedRecipesToMutableRecipesArray() // Reset recipes with the current sorting
    }
    
    // MARK: - recipeSearchTextSubscriber
    /// Main function to subscribe to recipe search text updates and handle them asynchronously with debounce.
    ///
    /// This function listens for updates to `recipeSearchText`, applies debouncing logic, and then triggers either a reset of recipes or filtering of search results based on the text. The logic ensures that searches are only triggered after the user has stopped typing for a defined period of time (debounce).
    private func recipeSearchTextSubscriber() {
        Task {
            var lastSearchTime = Date()
            let debounceDelay: TimeInterval = 0.1 // Define the debounce delay (0.1 seconds)
            
            // Create the debounced text stream to consume the latest recipe search text
            let debouncedTextStream = createDebouncedTextStream()
            
            // Iterate over the debounced text stream
            for await text in debouncedTextStream {
                // Handle the debounced search text asynchronously
                await handleDebouncedSearchText(text, lastSearchTime: &lastSearchTime, debounceDelay: debounceDelay)
            }
        }
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
    func filterSearchResult(text: String) {
        guard !text.isEmpty else {
            assignSortedRecipesToMutableRecipesArray()
            return
        }
        
        let lowercasedText: String = text.lowercased()
        let sortedRecipesArray: [RecipeModel] = sortRecipes(option: selectedSortOption)
        let filteredRecipesArray: [RecipeModel] = sortedRecipesArray.filter({
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
