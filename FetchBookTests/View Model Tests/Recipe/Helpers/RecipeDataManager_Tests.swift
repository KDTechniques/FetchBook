//
//  RecipeDataManager_Tests.swift
//  FetchBookTests
//
//  Created by Mr. Kavinda Dilshan on 2024-10-27.
//

import XCTest
@testable import FetchBook

@MainActor
final class RecipeDataManager_Tests: XCTestCase {
    // MARK: PROPERTIES
    var vm: RecipeViewModel!
    var recipeDataManager: RecipeDataManager!
    
    //MARK: FUNCTIONS
    
    // MARK: - setUpWithError
    override func setUpWithError() throws {
        // Initialize the mock service and view model before each test
        self.initialize()
    }
    
    // MARK: - tearDownWithError
    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }
    
    // MARK: Unit Tests
    
    // MARK: - test_RecipeDataManager_fetchRecipeData_shouldReturnEmptyArray
    /// Tests if `fetchAndUpdateRecipes` returns an empty array for the empty endpoint.
    ///
    /// This test verifies that when the `fetchAndUpdateRecipes` method is called with the empty endpoint,
    /// the view model's recipes array should be empty, and the appropriate data status is set.
    func test_RecipeDataManager_fetchRecipeData_shouldReturnEmptyArray() async {
        // Given, When & Then
        await emptyCheck(shouldReinitialize: true)
    }
    
    // MARK: - test_RecipeDataManager_fetchRecipeData_shouldThrowError
    /// Tests if `fetchAndUpdateRecipes` throws an error for a malformed endpoint.
    ///
    /// This test verifies that when the `fetchAndUpdateRecipes` method is called with a malformed endpoint,
    /// it should throw an error and set the appropriate data status.
    func test_RecipeDataManager_fetchRecipeData_shouldThrowError() async {
        // Given, When & Then
        await malformedCheck(shouldReinitialize: true)
    }
    
    // MARK: - test_RecipeDataManager_fetchRecipeData_shouldNotReturnEmptyArray
    /// Tests if `fetchAndUpdateRecipes` does not return an empty array for the all endpoint.
    ///
    /// This test verifies that when the `fetchAndUpdateRecipes` method is called with the all endpoint,
    /// the view model's recipes array should not be empty, and the appropriate data status is set.
    func test_RecipeDataManager_fetchRecipeData_shouldNotReturnEmptyArray() async {
        // Given, When & Then
        await allCheck(shouldReinitialize: true)
    }
    
    // MARK: - test_RecipeDataManager_fetchRecipeData_shouldPassAllPossibleEndpointPermutations
    /// Tests all permutations of `RecipeEndpointTypes` to ensure `fetchAndUpdateRecipes` works correctly.
    ///
    /// This test verifies that the `fetchAndUpdateRecipes` method handles all permutations of the endpoint types correctly.
    /// This simulates a real-life scenario where a user gets all the recipes, then receives malformed data or empty data
    /// after several seconds, or after a refresh.
    func test_RecipeDataManager_fetchRecipeData_shouldPassAllPossibleEndpointPermutations() async {
        // Given
        let endpoints: [RecipeEndpointTypes] = RecipeEndpointTypes.allCases
        /// ex: 1: [.all, .malformed, .empty], 2: [.malformed, .empty, .all], etc...
        let permutations: [[RecipeEndpointTypes]] = endpoints.generatePermutations()
        XCTAssertEqual(permutations.count, try endpoints.count.factorial())
        
        // When
        for permutation in permutations {
            for endpoint in permutation {
                switch endpoint {
                case .all:
                    // Given, When & Then
                    await allCheck(shouldReinitialize: false)
                case .empty:
                    // Given, When & Then
                    await emptyCheck(shouldReinitialize: false)
                case .malformed:
                    // Given, When & Then
                    await malformedCheck(shouldReinitialize: false)
                }
            }
        }
    }
}

// MARK: - EXTENSIONS
extension RecipeDataManager_Tests {
    // MARK: REUASBLE FUNCTIONS
    
    // MARK: - initialize
    /// Initializes the necessary components for testing.
    ///
    /// This function sets up the mock service and initializes the view model, sorting manager, and data manager
    /// before each test case.
    private func initialize() {
        let mockRecipeAPIService: RecipeServiceProtocol = MockRecipeAPIService()
        self.vm = .init(recipeService: mockRecipeAPIService)
        self.recipeDataManager = self.vm.dataManager
        
        XCTAssertEqual("\(vm.recipeService)", "\(mockRecipeAPIService)")
    }
    
    // MARK: - emptyCheck
    /// Checks the behavior of `fetchAndUpdateRecipes` when the endpoint returns an empty array.
    ///
    /// This function verifies that the data manager correctly handles an endpoint that returns an empty array of recipes.
    /// - Parameter shouldReinitialize: A boolean indicating whether the view model should be reinitialized after each iteration.
    private func emptyCheck(shouldReinitialize: Bool) async {
        // Given
        let sortOptions: [RecipeSortTypes] = RecipeSortTypes.allCases
        let endpoint: RecipeEndpointTypes = RecipeEndpointTypes.empty
        
        // When
        for option in sortOptions {
            vm.selectedSortTypeBinding.wrappedValue = option
            do {
                try await recipeDataManager.fetchAndUpdateRecipes(endpoint: endpoint)
            } catch {
                XCTFail("Expected successful fetch, but got error: \(error)")
            }
            
            // Then
            XCTAssertEqual(vm.currentDataStatus, .emptyData)
            XCTAssertTrue(vm.recipesArray.isEmpty)
            XCTAssertTrue(vm.mutableRecipesArray.isEmpty)
            XCTAssertEqual(vm.recipesArray, vm.mutableRecipesArray)
            XCTAssertEqual(vm.selectedSortType, option)
            
            if shouldReinitialize { self.initialize() }
        }
    }
    
    // MARK: - malformedCheck
    /// Checks the behavior of `fetchAndUpdateRecipes` when the endpoint returns a malformed response.
    ///
    /// This function verifies that the data manager correctly handles an endpoint that returns a malformed response.
    /// - Parameter shouldReinitialize: A boolean indicating whether the view model should be reinitialized after each iteration.
    private func malformedCheck(shouldReinitialize: Bool) async {
        // Given
        let sortOptions: [RecipeSortTypes] = RecipeSortTypes.allCases
        let endpoint: RecipeEndpointTypes = RecipeEndpointTypes.malformed
        
        // When
        for option in sortOptions {
            vm.selectedSortTypeBinding.wrappedValue = option
            do {
                try await recipeDataManager.fetchAndUpdateRecipes(endpoint: endpoint)
            } catch {
                // Then
                XCTAssertEqual(vm.currentDataStatus, .malformed)
                XCTAssertTrue(vm.recipesArray.isEmpty)
                XCTAssertTrue(vm.mutableRecipesArray.isEmpty)
                XCTAssertEqual(vm.recipesArray, vm.mutableRecipesArray)
                XCTAssertEqual(vm.selectedSortType, option)
                
                if shouldReinitialize { self.initialize() }
            }
        }
    }
    
    // MARK: - allCheck
    /// Checks the behavior of `fetchAndUpdateRecipes` when the endpoint returns a full array of recipes.
    ///
    /// This function verifies that the data manager correctly handles an endpoint that returns a full array of recipes.
    /// - Parameter shouldReinitialize: A boolean indicating whether the view model should be reinitialized after each iteration.
    private func allCheck(shouldReinitialize: Bool) async {
        // Given
        let sortOptions: [RecipeSortTypes] = RecipeSortTypes.allCases
        let endpoint: RecipeEndpointTypes = RecipeEndpointTypes.all
        
        // When
        for option in sortOptions {
            vm.selectedSortTypeBinding.wrappedValue = option
            do {
                try await recipeDataManager.fetchAndUpdateRecipes(endpoint: endpoint)
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
            
            XCTAssertEqual(vm.selectedSortType, option)
            
            if shouldReinitialize { self.initialize() }
        }
    }
}
