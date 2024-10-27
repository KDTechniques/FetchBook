//
//  RecipeDataManagerTests.swift
//  FetchBookTests
//
//  Created by Mr. Kavinda Dilshan on 2024-10-27.
//

import XCTest
@testable import FetchBook

@MainActor
final class RecipeDataManagerTests: XCTestCase {
    
    // MARK: PROPERTIES
    var vm: RecipeViewModel!
    var sortingManager: RecipeSortingManager!
    var recipeDataManager: RecipeDataManager!
    
    //MARK: FUNCTIONS
    
    // MARK: - setUpWithError
    override func setUpWithError() throws {
        // Initialize the mock service and view model before each test
        self.initialize()
    }
    
    // MARK: - tearDownWithError
    override func tearDownWithError() throws {
        
    }
    
    // MARK: Unit Tests
    
    // MARK: - test_RecipeDataManager_fetchRecipeData_shouldReturnEmptyArray
    /// Tests if `fetchRecipeData` returns an empty array for the empty endpoint.
    ///
    /// This test verifies that when the `fetchRecipeData` method is called with the empty endpoint,
    /// the view model's recipes array should be empty, and the appropriate data status is set.
    func test_RecipeDataManager_fetchRecipeData_shouldReturnEmptyArray() async {
        // Given, When & Then
        await emptyCheck(canReinitialize: true)
    }
    
    // MARK: - test_RecipeDataManager_fetchRecipeData_shouldThrowError
    /// Tests if `fetchRecipeData` throws an error for a malformed endpoint.
    ///
    /// This test verifies that when the `fetchRecipeData` method is called with a malformed endpoint,
    /// it should throw an error and set the appropriate data status.
    func test_RecipeDataManager_fetchRecipeData_shouldThrowError() async {
        // Given, When & Then
        await malformedCheck(canReinitialize: true)
    }
    
    // MARK: - test_RecipeDataManager_fetchRecipeData_shouldNotReturnEmptyArray
    /// Tests if `fetchRecipeData` does not return an empty array for the all endpoint.
    ///
    /// This test verifies that when the `fetchRecipeData` method is called with the all endpoint,
    /// the view model's recipes array should not be empty, and the appropriate data status is set.
    func test_RecipeDataManager_fetchRecipeData_shouldNotReturnEmptyArray() async {
        // Given, When & Then
        await allCheck(canReinitialize: true)
    }
    
    // MARK: - test_RecipeDataManager_fetchRecipeData_shouldPassAllPossiblePermutations
    /// Tests all permutations of `RecipeEndpointTypes` to ensure `fetchRecipeData` works correctly.
    ///
    /// This test verifies that the `fetchRecipeData` method handles all permutations of the endpoint types correctly.
    /// This simulates a real-life scenario where a user gets all the recipes, then receives malformed data or empty data
    /// after several seconds, or after a refresh.
    func test_RecipeDataManager_fetchRecipeData_shouldPassAllPossiblePermutations() async {
        // Given
        let endpoints: [RecipeEndpointTypes] = RecipeEndpointTypes.allCases
        /// ex: 1: [.all, .malformed, .empty], 2: [.malformed, .empty, .all], etc...
        let permutations: [[RecipeEndpointTypes]] = Helpers.generatePermutations(endpoints)
        XCTAssertEqual(permutations.count, try endpoints.count.factorial())
        
        // When
        for permutation in permutations {
            for endpoint in permutation {
                switch endpoint {
                case .all:
                    // Given, When & Then
                    await allCheck(canReinitialize: false)
                case .empty:
                    // Given, When & Then
                    await emptyCheck(canReinitialize: false)
                case .malformed:
                    // Given, When & Then
                    await malformedCheck(canReinitialize: false)
                }
            }
        }
    }
}

// MARK: - EXTENSIONS
extension RecipeDataManagerTests {
    // MARK: REUASBLE FUNCTIONS
    
    // MARK: - initialize
    /// Initializes the necessary components for testing.
    ///
    /// This function sets up the mock service and initializes the view model, sorting manager, and data manager
    /// before each test case.
    private func initialize() {
        let mockRecipeAPIService: RecipeServiceProtocol = MockRecipeAPIService()
        self.vm = .init(recipeService: mockRecipeAPIService)
        self.sortingManager = .init(recipeVM: vm)
        self.recipeDataManager = .init(recipeVM: vm, sortingManager: sortingManager, recipeService: mockRecipeAPIService)
        
        XCTAssertEqual("\(vm.recipeService)", "\(mockRecipeAPIService)")
    }
    
    // MARK: - emptyCheck
    /// Checks the behavior of `fetchRecipeData` when the endpoint returns an empty array.
    ///
    /// This function verifies that the data manager correctly handles an endpoint that returns an empty array of recipes.
    /// - Parameter canReinitialize: A boolean indicating whether the view model should be reinitialized after each iteration.
    private func emptyCheck(canReinitialize: Bool) async {
        // Given
        let sortOptions: [RecipeSortOptions] = RecipeSortOptions.allCases
        let endpoint: RecipeEndpointModel = RecipeEndpointTypes.empty.endpointModel
        
        // When
        for option in sortOptions {
            vm.selectedSortOptionBinding.wrappedValue = option
            
            do {
                try await recipeDataManager.fetchRecipeData(endpoint: endpoint)
            } catch {
                XCTFail("Expected successful fetch, but got error: \(error)")
            }
            
            // Then
            XCTAssertEqual(vm.currentDataStatus, .emptyData)
            XCTAssertTrue(vm.recipesArray.isEmpty)
            XCTAssertTrue(vm.mutableRecipesArray.isEmpty)
            XCTAssertEqual(vm.recipesArray, vm.mutableRecipesArray)
            XCTAssertEqual(vm.selectedSortOption, option)
            
            if canReinitialize { self.initialize() }
        }
    }
    
    // MARK: - malformedCheck
    /// Checks the behavior of `fetchRecipeData` when the endpoint returns a malformed response.
    ///
    /// This function verifies that the data manager correctly handles an endpoint that returns a malformed response.
    /// - Parameter canReinitialize: A boolean indicating whether the view model should be reinitialized after each iteration.
    private func malformedCheck(canReinitialize: Bool) async {
        // Given
        let sortOptions: [RecipeSortOptions] = RecipeSortOptions.allCases
        let endpoint: RecipeEndpointModel = RecipeEndpointTypes.malformed.endpointModel
        
        // When
        for option in sortOptions {
            vm.selectedSortOptionBinding.wrappedValue = option
            
            do {
                try await recipeDataManager.fetchRecipeData(endpoint: endpoint)
            } catch {
                // Then
                XCTAssertEqual(vm.currentDataStatus, .malformed)
                XCTAssertTrue(vm.recipesArray.isEmpty)
                XCTAssertTrue(vm.mutableRecipesArray.isEmpty)
                XCTAssertEqual(vm.recipesArray, vm.mutableRecipesArray)
                XCTAssertEqual(vm.selectedSortOption, option)
                
                if canReinitialize { self.initialize() }
            }
        }
    }
    
    // MARK: - allCheck
    /// Checks the behavior of `fetchRecipeData` when the endpoint returns a full array of recipes.
    ///
    /// This function verifies that the data manager correctly handles an endpoint that returns a full array of recipes.
    /// - Parameter canReinitialize: A boolean indicating whether the view model should be reinitialized after each iteration.
    private func allCheck(canReinitialize: Bool) async {
        // Given
        let sortOptions: [RecipeSortOptions] = RecipeSortOptions.allCases
        let endpoint: RecipeEndpointModel = RecipeEndpointTypes.all.endpointModel
        
        // When
        for option in sortOptions {
            vm.selectedSortOptionBinding.wrappedValue = option
            
            do {
                try await recipeDataManager.fetchRecipeData(endpoint: endpoint)
            } catch {
                XCTFail("Expected successful fetch, but got error: \(error)")
            }
            
            // Then
            XCTAssertEqual(vm.currentDataStatus, .none)
            XCTAssertFalse(vm.recipesArray.isEmpty)
            XCTAssertFalse(vm.mutableRecipesArray.isEmpty)
            XCTAssertEqual(vm.recipesArray.count, vm.mutableRecipesArray.count)
            
            if option == .none {
                XCTAssertEqual(vm.recipesArray, vm.mutableRecipesArray)
            } else {
                XCTAssertNotEqual(vm.recipesArray, vm.mutableRecipesArray)
            }
            
            XCTAssertEqual(vm.selectedSortOption, option)
            
            if canReinitialize { self.initialize() }
        }
    }
}
