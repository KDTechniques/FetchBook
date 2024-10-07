//
//  RecipeViewModelTests.swift
//  FetchBookTests
//
//  Created by Mr. Kavinda Dilshan on 2024-10-05.
//

import XCTest
import Combine
@testable import FetchBook

final class RecipeViewModelTests: XCTestCase {
    
    /// The instance of `RecipeViewModel` used for testing.
    ///
    /// - This property is implicitly unwrapped to avoid optional handling in test cases.
    /// - It is initialized in the `setUpWithError()` method before each test case.
    /// - Tests will use this instance to verify the behavior of the view model's logic.
    var vm: RecipeViewModel!
    
    /// Sets up the environment before each test is run, initializing the view model with a mock recipe service.
    ///
    /// - This method is called before each test case is executed.
    /// - A mock implementation of the `RecipeDataFetching` protocol (`MockRecipeAPIService`) is instantiated to simulate network requests during testing.
    /// - The view model (`vm`) is initialized with the mock service to ensure that no actual network requests are made.
    /// - Asserts that the view model's `recipeService` property is correctly set to the mock service.
    override func setUpWithError() throws {
        // Initialize the mock service and view model before each test
        let mockRecipeAPIService: RecipeDataFetching = MockRecipeAPIService()
        vm = .init(recipeService: mockRecipeAPIService)
        XCTAssertEqual("\(vm.recipeService)", "\(mockRecipeAPIService)")
    }
    
    override func tearDownWithError() throws { }
    
    /// Executes a given action on the main thread.
    ///
    /// - This function ensures that the provided closure is executed on the main thread,
    ///   which is useful for performing UI updates or actions that must be performed on the main thread.
    /// - Uses a weak reference to `self` to avoid retain cycles, ensuring that the action is only executed if `self` still exists.
    ///
    /// - Parameter action: A closure that takes `self` as a parameter and performs an action.
    func executeOnMainThread(action: @escaping (_ self: RecipeViewModelTests) -> ()) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            action(self)
        }
    }
    
    // MARK: - Unit Tests
    
    // MARK: - fetchRecipeData(endpoint: RecipeEndpointModel) async throws Unit Tests
    
    // MARK: - test_RecipeViewModel_fetchRecipeData_shouldNotReturnEmptyArray
    /// Tests the `fetchRecipeData` method in `RecipeViewModel` to ensure it does not return an empty array after fetching.
    ///
    /// - Given: The mock service is set up to return a predefined number of recipes.
    /// - When: The `fetchRecipeData` method is called with the endpoint for all recipes.
    /// - Then: The test asserts that the `recipesArray` and `mutableRecipesArray` are populated with the expected number of recipes, and the `currentDataStatus` reflects a successful fetch.
    func test_RecipeViewModel_fetchRecipeData_shouldNotReturnEmptyArray() async {
        // Given
        let expectedRecipeCount: Int = 4 // Assuming the mock data has 4 recipes
        
        do {
            // When
            try await vm.fetchRecipeData(endpoint: RecipeEndpoints.all)
            
            executeOnMainThread {
                // Then
                XCTAssertFalse($0.vm.recipesArray.isEmpty)
                XCTAssertEqual($0.vm.recipesArray.count, expectedRecipeCount)
                XCTAssertFalse($0.vm.mutableRecipesArray.isEmpty)
                XCTAssertEqual($0.vm.mutableRecipesArray.count, expectedRecipeCount)
                XCTAssertEqual($0.vm.currentDataStatus, .none)
            }
        } catch {
            XCTFail("Expected successful fetch, but got error: \(error)")
        }
    }
    
    // MARK: - test_RecipeViewModel_fetchRecipeData_shouldHandleEmptyResponse
    /// Tests the `fetchRecipeData` method in `RecipeViewModel` to ensure it handles an empty response correctly.
    ///
    /// - Given: A simulated empty response scenario using a predefined endpoint.
    /// - When: The `fetchRecipeData` method is called with the empty endpoint.
    /// - Then: The test asserts that both `recipesArray` and `mutableRecipesArray` are empty,
    ///         and the `currentDataStatus` is updated to reflect the empty data state.
    func test_RecipeViewModel_fetchRecipeData_shouldHandleEmptyResponse() async {
        // Given
        let endpoint: RecipeEndpointModel = RecipeEndpoints.empty // Simulating empty response
        
        do {
            // When
            try await vm.fetchRecipeData(endpoint: endpoint)
            
            executeOnMainThread {
                // Then
                XCTAssertTrue($0.vm.recipesArray.isEmpty, "Recipe array should be empty for an empty response")
                XCTAssertTrue($0.vm.mutableRecipesArray.isEmpty, "Sorted recipe array should be empty for an empty response")
                XCTAssertEqual($0.vm.currentDataStatus, .emptyData)
            }
        } catch {
            XCTFail("Expected successful fetch with empty response, but got error: \(error)")
        }
    }
    
    // MARK: - test_RecipeViewModel_fetchRecipeData_shouldHandleMalformedResponse
    /// Tests the `fetchRecipeData` method in `RecipeViewModel` to ensure it handles a malformed response correctly.
    ///
    /// - Given: A simulated malformed response scenario using a predefined endpoint.
    /// - When: The `fetchRecipeData` method is called with the malformed endpoint.
    /// - Then: The test asserts that the fetch operation throws an error, and that the `recipesArray` is empty.
    ///         It also checks that the `currentDataStatus` is updated to reflect a malformed data state.
    func test_RecipeViewModel_fetchRecipeData_shouldHandleMalformedResponse() async {
        // Given
        let endpoint: RecipeEndpointModel = RecipeEndpoints.malformed // Simulating malformed data
        
        do {
            // When
            try await vm.fetchRecipeData(endpoint: endpoint)
            XCTFail("Expected error for malformed response, but got success")
        } catch {
            executeOnMainThread {
                // Then
                XCTAssertEqual($0.vm.recipesArray.count, 0, "Recipe array should be empty after a malformed response")
                XCTAssertEqual($0.vm.currentDataStatus, .malformed)
            }
        }
    }
    
    // MARK: - test_RecipeViewModel_recipesArrayShouldReturnCorrectData
    /// Tests the `fetchRecipeData` method in `RecipeViewModel` to ensure that the `recipesArray` contains the correct data after fetching.
    ///
    /// - Given: A predefined endpoint that returns mock data, specifically checking for the name of the first recipe.
    /// - When: The `fetchRecipeData` method is called with the specified endpoint to retrieve recipe data.
    /// - Then: The test asserts that the first recipe in the `recipesArray` matches the expected name,
    ///         and checks that the `currentDataStatus` is updated to reflect a successful fetch.
    func test_RecipeViewModel_fetchRecipeData_recipesArrayShouldReturnCorrectData() async {
        // Given
        let expectedFirstRecipeName: String = "Pear Tarte Tatin" // Based on mock data
        let endpoint: RecipeEndpointModel = RecipeEndpoints.all
        
        do {
            // When
            try await vm.fetchRecipeData(endpoint: endpoint)
            
            executeOnMainThread {
                // Then
                XCTAssertEqual($0.vm.recipesArray.first?.name, expectedFirstRecipeName)
                XCTAssertEqual($0.vm.currentDataStatus, .none)
            }
        } catch {
            XCTFail("Expected successful fetch, but got an error: \(error)")
        }
    }
    
    // MARK: - sortRecipes(option: SortOptions) -> [RecipeModel]  Unit Tests
    
    // MARK: - test_RecipeViewModel_sortRecipes_shouldSortAZ
    /// Tests the `sortRecipes` method in `RecipeViewModel` to ensure that recipes are sorted in A-Z order.
    ///
    /// - Given: A successful fetch of recipe data to ensure there are recipes available to sort.
    /// - When: The `sortRecipes` method is called with the A-Z sorting option.
    /// - Then: The test asserts that the first recipe in the sorted array is the expected first recipe,
    ///         the last recipe in the sorted array is the expected last recipe, and checks that
    ///         the `currentDataStatus` is updated to reflect a successful sort.
    func test_RecipeViewModel_sortRecipes_shouldSortAZ() async {
        do {
            // Given
            try await vm.fetchRecipeData(endpoint: RecipeEndpoints.all)
            let expectedFirstRecipeName: String = "Apam Balik" // A is the first in A-Z sorting
            let expectedLastRecipeName: String = "Treacle Tart" // T is the last in A-Z sorting
            
            executeOnMainThread {
                // When
                let sortedRecipes: [RecipeModel] = $0.vm.sortRecipes(option: .az)
                
                // Then
                XCTAssertEqual(sortedRecipes.first?.name, expectedFirstRecipeName, "The first recipe in A-Z sort should be \(expectedFirstRecipeName)")
                XCTAssertEqual(sortedRecipes.last?.name, expectedLastRecipeName, "The last recipe in A-Z sort should be \(expectedLastRecipeName)")
                XCTAssertEqual($0.vm.currentDataStatus, .none)
            }
        } catch {
            XCTFail("Expected successful fetch & sort, but got an error: \(error)")
        }
    }
    
    // MARK: - test_RecipeViewModel_sortRecipes_shouldSortZA
    /// Tests the `sortRecipes` method in `RecipeViewModel` to ensure that recipes are sorted in Z-A order.
    ///
    /// - Given: A successful fetch of recipe data to ensure there are recipes available to sort.
    /// - When: The `sortRecipes` method is called with the Z-A sorting option.
    /// - Then: The test asserts that the first recipe in the sorted array is the expected first recipe,
    ///         the last recipe in the sorted array is the expected last recipe, and checks that
    ///         the `currentDataStatus` is updated to reflect a successful sort.
    func test_RecipeViewModel_sortRecipes_shouldSortZA() async throws {
        do {
            // Given
            try await vm.fetchRecipeData(endpoint: RecipeEndpoints.all)
            let expectedFirstRecipeName = "Treacle Tart" // T is the first in Z-A sorting
            let expectedLastRecipeName = "Apam Balik" // A is the last in Z-A sorting
            
            executeOnMainThread {
                // When
                let sortedRecipes: [RecipeModel] = $0.vm.sortRecipes(option: .za)
                
                // Then
                XCTAssertEqual(sortedRecipes.first?.name, expectedFirstRecipeName, "The first recipe in Z-A sort should be \(expectedFirstRecipeName)")
                XCTAssertEqual(sortedRecipes.last?.name, expectedLastRecipeName, "The last recipe in Z-A sort should be \(expectedLastRecipeName)")
                XCTAssertEqual($0.vm.currentDataStatus, .none)
            }
        }  catch {
            XCTFail("Expected successful fetch & sort, but got an error: \(error)")
        }
    }
    
    // MARK: - test_RecipeViewModel_sortRecipes_shouldReturnUnsortedArray
    func test_RecipeViewModel_sortRecipes_shouldReturnUnsortedArray() async {
        do {
            // Given
            try await vm.fetchRecipeData(endpoint: RecipeEndpoints.all)
            let expectedRecipeCount: Int = 4 // Assuming the mock data has 4 recipes
            let notExpectedRecipeDescription: String = "[]"
            
            executeOnMainThread {
                // When
                let originalRecipesArray = $0.vm.recipesArray // Original unsorted array
                let unsortedRecipes: [RecipeModel] = $0.vm.sortRecipes(option: .none)
                
                // Then
                XCTAssertEqual(originalRecipesArray.count, expectedRecipeCount, "The original recipes array should return the mock data set count")
                XCTAssertEqual(unsortedRecipes.count, expectedRecipeCount, "The unsorted option should return the mock data set count")
                
                XCTAssertNotEqual(originalRecipesArray.description, notExpectedRecipeDescription, "The original recipes array should not return empty array description")
                XCTAssertNotEqual(unsortedRecipes.description, notExpectedRecipeDescription, "The unsorted option should not return empty array description")
                
                XCTAssertEqual(unsortedRecipes, originalRecipesArray, "The unsorted option should return the original recipes array")
                XCTAssertEqual(unsortedRecipes.description, originalRecipesArray.description, "The unsorted option should return the original recipes array description")
                XCTAssertEqual(unsortedRecipes.count, originalRecipesArray.count, "The unsorted option should return the original recipes array count")
                
                XCTAssertEqual($0.vm.currentDataStatus, .none)
            }
        } catch {
            XCTFail("Expected successful fetch & equal arrays, but got an error: \(error)")
        }
    }
    
    // MARK: - test_RecipeViewModel_sortRecipes_shouldHandleEmptyArray
    /// Tests the `sortRecipes` method in `RecipeViewModel` to ensure that when no sorting option is selected,
    /// the original array of recipes is returned unchanged.
    ///
    /// - Given: A successful fetch of recipe data to ensure there are recipes available for comparison.
    /// - When: The `sortRecipes` method is called with the unsorted option.
    /// - Then: The test asserts that the original recipes array and the returned unsorted array have the same count,
    ///         do not return an empty description, and that the unsorted array matches the original array exactly.
    func test_RecipeViewModel_sortRecipes_shouldHandleEmptyArray() async {
        do {
            // Given
            try await vm.fetchRecipeData(endpoint: RecipeEndpoints.empty) // Simulating empty response
            let expectedRecipeCount: Int = 0
            
            executeOnMainThread {
                // When
                let sortedRecipesAZ: [RecipeModel] = $0.vm.sortRecipes(option: .az)
                let sortedRecipesZA: [RecipeModel] = $0.vm.sortRecipes(option: .za)
                let unsortedRecipes: [RecipeModel] = $0.vm.sortRecipes(option: .none)
                
                // Then
                XCTAssertTrue(sortedRecipesAZ.isEmpty, "Sorting an empty array A-Z should return an empty array")
                XCTAssertEqual(sortedRecipesAZ.count, expectedRecipeCount, "Sorting an empty array A-Z should return an empty array")
                
                XCTAssertTrue(sortedRecipesZA.isEmpty, "Sorting an empty array Z-A should return an empty array")
                XCTAssertEqual(sortedRecipesZA.count, expectedRecipeCount, "Sorting an empty array Z-A should return an empty array")
                
                XCTAssertTrue(unsortedRecipes.isEmpty, "Returning unsorted array should return an empty array")
                XCTAssertEqual(sortedRecipesAZ.count, expectedRecipeCount, "Returning unsorted array should return an empty array")
                
                XCTAssertEqual($0.vm.currentDataStatus, .emptyData)
            }
        } catch {
            XCTFail("Expected successful fetch & empty arrays, but got an error: \(error)")
        }
    }
    
    // MARK: - sortOptionSubscriber()  Unit Tests
    
    // MARK: - test_RecipeViewModel_sortOptionSubscriber_shouldSortAZ
    /// Tests the `selectedSortOption` property in `RecipeViewModel` to ensure that setting it to the A-Z option
    /// results in the recipes being sorted correctly.
    ///
    /// - Given: A successful fetch of recipe data to ensure the mutable array is populated before sorting.
    /// - When: The `selectedSortOption` property is set to `.az`.
    /// - Then: The test asserts that the first and last recipes in the `mutableRecipesArray` are the expected ones
    ///         after sorting and that the `currentDataStatus` reflects a successful operation.
    func test_RecipeViewModel_sortOptionSubscriber_shouldSortAZ() async {
        do {
            // Given
            try await vm.fetchRecipeData(endpoint: RecipeEndpoints.all)
            let expectedFirstRecipeName: String = "Apam Balik" // A is the first in A-Z sorting
            let expectedLastRecipeName: String = "Treacle Tart" // T is the last in A-Z sorting
            
            executeOnMainThread {
                // When
                $0.vm.selectedSortOption = .az
                
                // Then
                XCTAssertEqual($0.vm.mutableRecipesArray.first?.name, expectedFirstRecipeName, "The first recipe in A-Z sort should be \(expectedFirstRecipeName)")
                XCTAssertEqual($0.vm.mutableRecipesArray.last?.name, expectedLastRecipeName, "The last recipe in A-Z sort should be \(expectedLastRecipeName)")
                XCTAssertEqual($0.vm.currentDataStatus, .none)
            }
        } catch {
            XCTFail("Expected successful fetch & sorted array, but got an error: \(error)")
        }
    }
    
    // MARK: - test_RecipeViewModel_sortOptionSubscriber_shouldSortZA
    /// Tests the `selectedSortOption` property in `RecipeViewModel` to ensure that setting it to the Z-A option
    /// results in the recipes being sorted correctly.
    ///
    /// - Given: A successful fetch of recipe data to ensure the mutable array is populated before sorting.
    /// - When: The `selectedSortOption` property is set to `.za`.
    /// - Then: The test asserts that the first and last recipes in the `mutableRecipesArray` are the expected ones
    ///         after sorting and that the `currentDataStatus` reflects a successful operation.
    func test_RecipeViewModel_sortOptionSubscriber_shouldSortZA() async {
        do {
            // Given
            try await vm.fetchRecipeData(endpoint: RecipeEndpoints.all)
            let expectedFirstRecipeName: String = "Treacle Tart" // T is the first in A-Z sorting
            let expectedLastRecipeName: String = "Apam Balik" // A is the last in A-Z sorting
            
            executeOnMainThread {
                // When
                $0.vm.selectedSortOption = .za
                
                // Then
                XCTAssertEqual($0.vm.mutableRecipesArray.first?.name, expectedFirstRecipeName, "The first recipe in Z-A sort should be \(expectedFirstRecipeName)")
                XCTAssertEqual($0.vm.mutableRecipesArray.last?.name, expectedLastRecipeName, "The last recipe in Z-A sort should be \(expectedLastRecipeName)")
                XCTAssertEqual($0.vm.currentDataStatus, .none)
            }
        } catch {
            XCTFail("Expected successful fetch & sorted array, but got an error: \(error)")
        }
    }
    
    // MARK: - recipeSearchTextSubscriber() Unit Tests
    
    // MARK: - test_RecipeViewModel_recipeSearchTextSubscriber_emptySearchText_shouldReturnAllRecipes
    /// Tests the behavior of the `recipeSearchText` property in `RecipeViewModel` when the search text is empty.
    ///
    /// - Given: A successful fetch of recipe data to ensure the mutable array is populated before testing the search functionality.
    /// - When: The `recipeSearchText` property is set to an empty string.
    /// - Then: The test asserts that the `mutableRecipesArray` contains all recipes and matches the original `recipesArray`.
    func test_RecipeViewModel_recipeSearchTextSubscriber_emptySearchText_shouldReturnAllRecipes() async {
        do {
            // Given
            try await vm.fetchRecipeData(endpoint: RecipeEndpoints.all)
            let expectedRecipeCount: Int = 4 // Assuming the mock data has 4 recipes
            executeOnMainThread { $0.vm.recipeSearchText = "" /* Set search text to empty */ }
            
            // When
            try await Task.sleep(nanoseconds: 200_000_000) // Wait for debounce to complete
            
            executeOnMainThread {
                // Then
                XCTAssertEqual($0.vm.mutableRecipesArray.count, expectedRecipeCount, "When search text is empty, mutableRecipesArray count should match the expected recipe count")
                XCTAssertEqual($0.vm.mutableRecipesArray, $0.vm.recipesArray, "When search text is empty, mutableRecipesArray should match the original recipesArray")
                XCTAssertEqual($0.vm.mutableRecipesArray.count, $0.vm.recipesArray.count, "When search text is empty, mutableRecipesArray count should match the original recipesArray count")
                XCTAssertEqual($0.vm.mutableRecipesArray.description, $0.vm.recipesArray.description, "When search text is empty, mutableRecipesArray description should match the original recipesArray description")
                XCTAssertEqual($0.vm.currentDataStatus, .none)
            }
        } catch {
            XCTFail("Expected successful fetch & original array results, but got an error: \(error)")
        }
    }
    
    // MARK: - test_RecipeViewModel_recipeSearchTextSubscriber_nonEmptySearchText_shouldFilterRecipes
    /// Tests the behavior of the `recipeSearchText` property in `RecipeViewModel` when the search text is non-empty.
    ///
    /// - Given: A successful fetch of recipe data to ensure the mutable array is populated before testing the search functionality.
    /// - When: The `recipeSearchText` property is set to a specific non-empty value to filter recipes.
    /// - Then: The test asserts that the `mutableRecipesArray` contains only the filtered results matching the search text.
    func test_RecipeViewModel_recipeSearchTextSubscriber_nonEmptySearchText_shouldFilterRecipes() async {
        do {
            // Given
            try await vm.fetchRecipeData(endpoint: RecipeEndpoints.all)
            let searchText:String = "Buns"
            let expectedRecipeName: String = "Chelsea Buns"
            let expectedRecipeCount: Int = 1
            
            // When
            executeOnMainThread { $0.vm.recipeSearchText = searchText /* Set search text to filter results */ }
            try await Task.sleep(nanoseconds: 200_000_000) // Wait for debounce to complete
            
            executeOnMainThread {
                // Then
                XCTAssertEqual($0.vm.mutableRecipesArray.count, expectedRecipeCount, "Filtered results should only contain expected recipe count")
                XCTAssertEqual($0.vm.mutableRecipesArray.first?.name, expectedRecipeName, "The filtered recipe should match \(expectedRecipeName)")
                XCTAssertEqual($0.vm.currentDataStatus, .none)
            }
        } catch {
            XCTFail("Expected successful fetch & filtered array results, but got an error: \(error)")
        }
    }
    
    // MARK: - test_RecipeViewModel_recipeSearchTextSubscriber_searchText_noMatches_shouldReturnEmptyArray
    /// Tests the behavior of the `recipeSearchText` property in `RecipeViewModel` when the search text does not match any recipe.
    ///
    /// - Given: A successful fetch of recipe data to ensure the mutable array is populated before testing the search functionality.
    /// - When: The `recipeSearchText` property is set to a non-matching value to filter recipes.
    /// - Then: The test asserts that the `mutableRecipesArray` is empty when no recipes match the search text.
    func test_RecipeViewModel_recipeSearchTextSubscriber_searchText_noMatches_shouldReturnEmptyArray() async {
        do {
            // Given
            try await vm.fetchRecipeData(endpoint: RecipeEndpoints.all)
            let searchText: String = "NonExistentRecipe"
            
            // When
            executeOnMainThread { $0.vm.recipeSearchText = searchText /* Set a search text that does not match any recipe */ }
            try await Task.sleep(nanoseconds: 200_000_000) // Wait for debounce to complete
            
            executeOnMainThread {
                // Then
                XCTAssertTrue($0.vm.mutableRecipesArray.isEmpty, "If no recipe matches the search text, mutableRecipesArray should be empty")
                XCTAssertEqual($0.vm.currentDataStatus, .emptyResult)
            }
        } catch {
            XCTFail("Expected successful fetch & empty array result, but got an error: \(error)")
        }
    }
    
    // MARK: - test_RecipeViewModel_recipeSearchTextSubscriber_searchTextCaseInsensitiveMatching_shouldFilterCorrectly
    /// Tests the behavior of the `recipeSearchText` property in `RecipeViewModel` for case-insensitive matching of recipe names.
    ///
    /// - Given: A successful fetch of recipe data to ensure the mutable array is populated before testing the search functionality.
    /// - When: The `recipeSearchText` property is set to a mixed-case value to filter recipes.
    /// - Then: The test asserts that the filtered results match the expected recipe, demonstrating that the search is case-insensitive.
    func test_RecipeViewModel_recipeSearchTextSubscriber_searchTextCaseInsensitiveMatching_shouldFilterCorrectly() async {
        do {
            // Given
            try await vm.fetchRecipeData(endpoint: RecipeEndpoints.all)
            let searchText = "ChELsEa" // mixed case search text for a case-insensitive search
            let expectedRecipeName = "Chelsea Buns"
            let expectedRecipeCount: Int = 1
            
            // When
            executeOnMainThread { $0.vm.recipeSearchText = searchText /* Set a search text that contains multiple cases */ }
            try await Task.sleep(nanoseconds: 200_000_000) // Wait for debounce to complete
            
            executeOnMainThread {
                // Then
                XCTAssertEqual($0.vm.mutableRecipesArray.count, expectedRecipeCount, "Filtered results should only contain expected recipe count")
                XCTAssertEqual($0.vm.mutableRecipesArray.first?.name, expectedRecipeName, "Search should be case-insensitive and match \(expectedRecipeName)")
                XCTAssertEqual($0.vm.currentDataStatus, .none)
            }
        } catch {
            XCTFail("Expected successful fetch & filtered array result, but got an error: \(error)")
        }
    }
    
    // MARK: - filterSearchResult(text: String)  Unit Tests
    
    // MARK: - test_RecipeViewModel_filterSearchResult_shouldReturnFilteredRecipes_basedOnName
    /// Tests the filtering functionality of the `filterSearchResult` method in `RecipeViewModel`.
    ///
    /// - Given: The recipe data is successfully fetched, ensuring that the mutable array is populated with recipes.
    /// - When: The `filterSearchResult` method is called with a search text that matches a recipe name.
    /// - Then: The test asserts that the filtered results contain only the expected recipe based on the search text.
    func test_RecipeViewModel_filterSearchResult_shouldReturnFilteredRecipes_basedOnName() async {
        do {
            // Given
            try await vm.fetchRecipeData(endpoint: RecipeEndpoints.all)
            let searchText = "Apam" // A recipe name from the mock data
            let expectedRecipeName = "Apam Balik"
            let expectedRecipeCount: Int = 1
            
            executeOnMainThread {
                // When
                $0.vm.filterSearchResult(text: searchText)
                
                // Then
                XCTAssertFalse($0.vm.mutableRecipesArray.isEmpty)
                XCTAssertEqual($0.vm.mutableRecipesArray.count, expectedRecipeCount, "Filtered results should only contain expected recipe count")
                XCTAssertEqual($0.vm.mutableRecipesArray.first?.name, expectedRecipeName, "The filtered recipe should match \(expectedRecipeName)")
                XCTAssertEqual($0.vm.currentDataStatus, .none)
            }
        } catch {
            XCTFail("Expected successful fetch & filtered array result, but got an error: \(error)")
        }
    }
    
    // MARK: - test_RecipeViewModel_filterSearchResult_shouldReturnFilteredRecipes_basedOnCuisine
    /// Tests the filtering functionality of the `filterSearchResult` method in `RecipeViewModel`
    /// based on the cuisine type.
    ///
    /// - Given: The recipe data is successfully fetched, ensuring that the mutable array is populated with recipes.
    /// - When: The `filterSearchResult` method is called with a search text that matches a cuisine type.
    /// - Then: The test asserts that the filtered results contain only the expected recipe based on the cuisine type.
    func test_RecipeViewModel_filterSearchResult_shouldReturnFilteredRecipes_basedOnCuisine() async {
        do {
            // Given
            try await vm.fetchRecipeData(endpoint: RecipeEndpoints.all)
            let searchText = "French" // A cuisine from the mock data
            let expectedCuisineName = "French"
            let expectedRecipeCount: Int = 1
            
            executeOnMainThread {
                // When
                $0.vm.filterSearchResult(text: searchText)
                
                // Then
                XCTAssertFalse($0.vm.mutableRecipesArray.isEmpty)
                XCTAssertEqual($0.vm.mutableRecipesArray.count, expectedRecipeCount, "Filtered results should only contain expected recipe count")
                XCTAssertEqual($0.vm.mutableRecipesArray.first?.cuisine, expectedCuisineName, "The filtered recipe should match \(expectedCuisineName)")
                XCTAssertEqual($0.vm.currentDataStatus, .none)
            }
        } catch {
            XCTFail("Expected successful fetch & filtered array result, but got an error: \(error)")
        }
    }
    
    // MARK: - test_RecipeViewModel_filterSearchResult_shouldHandleCaseInsensitiveSearch
    /// Tests the filtering functionality of the `filterSearchResult` method in `RecipeViewModel`
    /// to ensure it correctly handles case-insensitive searches.
    ///
    /// - Given: The recipe data is successfully fetched, ensuring that the mutable array is populated with recipes.
    /// - When: The `filterSearchResult` method is called with a search text that has mixed case.
    /// - Then: The test asserts that the filtered results contain the expected recipe, demonstrating case-insensitive matching.
    func test_RecipeViewModel_filterSearchResult_shouldHandleCaseInsensitiveSearch() async {
        do {
            // Given
            try await vm.fetchRecipeData(endpoint: RecipeEndpoints.all)
            let searchText = "treAcLE" // Test mixed case
            let expectedRecipeName = "Treacle Tart"
            let expectedRecipeCount: Int = 1
            
            executeOnMainThread {
                // When
                $0.vm.filterSearchResult(text: searchText)
                
                // Then
                XCTAssertFalse($0.vm.mutableRecipesArray.isEmpty)
                XCTAssertEqual($0.vm.mutableRecipesArray.count, expectedRecipeCount, "Filtered results should only contain expected recipe count")
                XCTAssertEqual($0.vm.mutableRecipesArray.first?.name, expectedRecipeName, "The filtered recipe should match \(expectedRecipeName)")
                XCTAssertEqual($0.vm.currentDataStatus, .none)
            }
        } catch {
            XCTFail("Expected successful fetch & filtered array result, but got an error: \(error)")
        }
    }
    
    //  MARK: - test_RecipeViewModel_filterSearchResult_shouldReturnEmptyArray_whenNoMatch
    /// Tests the filtering functionality of the `filterSearchResult` method in `RecipeViewModel`
    /// to ensure it returns an empty array when no matching recipes are found.
    ///
    /// - Given: The recipe data is successfully fetched, ensuring that the mutable array is populated with recipes.
    /// - When: The `filterSearchResult` method is called with a search text that does not match any recipe.
    /// - Then: The test asserts that the mutable array is empty and the data status indicates an empty result.
    func test_RecipeViewModel_filterSearchResult_shouldReturnEmptyArray_whenNoMatch() async {
        do {
            // Given
            try await vm.fetchRecipeData(endpoint: RecipeEndpoints.all)
            let searchText = "NonExistentRecipe"
            
            executeOnMainThread {
                // When
                $0.vm.filterSearchResult(text: searchText)
                
                // Then
                XCTAssertTrue($0.vm.mutableRecipesArray.isEmpty) // No recipes should match
                XCTAssertEqual($0.vm.currentDataStatus, .emptyResult)
            }
        } catch {
            XCTFail("Expected successful fetch & empty array result, but got an error: \(error)")
        }
    }
    
    // MARK: - test_RecipeViewModel_filterSearchResult_shouldReturnFullArray_whenSearchTextIsEmpty
    /// Tests the behavior of the `filterSearchResult` method in `RecipeViewModel`
    /// when the search text is empty, ensuring that the full array of recipes is returned.
    ///
    /// - Given: Recipe data is successfully fetched, ensuring that the mutable array is populated with recipes.
    /// - When: The `filterSearchResult` method is called with an empty search text.
    /// - Then: The test asserts that the mutable array matches the original recipes array, indicating no filtering occurred.
    func test_RecipeViewModel_filterSearchResult_shouldReturnFullArray_whenSearchTextIsEmpty() async {
        do {
            // Given
            try await vm.fetchRecipeData(endpoint: RecipeEndpoints.all)
            let searchText = "" // Empty search
            
            executeOnMainThread {
                // When
                $0.vm.filterSearchResult(text: searchText)
                
                // Then
                XCTAssertEqual($0.vm.mutableRecipesArray.count, $0.vm.recipesArray.count, "The original recipes array should return the mock data set count")
                XCTAssertEqual($0.vm.currentDataStatus, .none)
            }
        }  catch {
            XCTFail("Expected successful fetch & full array result, but got an error: \(error)")
        }
    }
}
