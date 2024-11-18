// RecipeViewModel_Tests.swift
//  FetchBookTests
//
//  Created by Mr. Kavinda Dilshan on 2024-11-01.
//
import XCTest
@testable import FetchBook

@MainActor
final class RecipeViewModel_Tests: XCTestCase {
    // MARK: - PROPERTIES
    var vm: RecipeViewModel!
    
    // MARK: FUNCTIONS
    
    // MARK: - setUpWithError
    override func setUpWithError() throws {
        self.initialize()
    }
    
    // MARK: - tearDownWithError
    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }
    
    // MARK: - UNIT TESTS
    
    // MARK: - test_RecipeViewModel_recipeSearchTextBinding_shouldReturnString
    /// Tests if the `recipeSearchTextBinding` returns the expected string value.
    ///
    /// This test verifies that when the `recipeSearchTextBinding` is updated with different string values,
    /// the `recipeSearchText` property in the view model reflects the correct value.
    func test_RecipeViewModel_recipeSearchTextBinding_shouldReturnString() {
        // Given
        let textsArray: [String] = [UUID().uuidString, ""]
        
        // When
        for text in textsArray {
            vm.recipeSearchTextBinding.wrappedValue = text
            
            // Then
            XCTAssertEqual(vm.recipeSearchText, text)
        }
    }
    
    // MARK: - test_RecipeViewModel_selectedSortTypeBinding_shouldReturnSortType
    /// Tests if the `selectedSortTypeBinding` returns the expected sort type.
    ///
    /// This test verifies that when the `selectedSortTypeBinding` is updated with different sort types,
    /// the `selectedSortType` property in the view model reflects the correct value.
    func test_RecipeViewModel_selectedSortTypeBinding_shouldReturnSortType() {
        // Given
        let sortTypesArray: [RecipeSortTypes] = RecipeSortTypes.allCases
        
        // When
        for sortType in sortTypesArray {
            vm.selectedSortTypeBinding.wrappedValue = sortType
            
            // Then
            XCTAssertEqual(vm.selectedSortType, sortType)
        }
    }
    
    // MARK: - test_RecipeViewModel_selectedEndpointBinding_shouldReturnEndpointModel
    /// Tests if the `selectedEndpointBinding` returns the expected endpoint model.
    ///
    /// This test verifies that when the `selectedEndpointBinding` is updated with different endpoint models,
    /// the `selectedEndpoint` property in the view model reflects the correct value.
    func test_RecipeViewModel_selectedEndpointBinding_shouldReturnEndpointModel() {
        // Given
        let endpointTypesArray: [RecipeEndpointTypes] = RecipeEndpointTypes.allCases
        
        // When
        for endpointType in endpointTypesArray {
            vm.selectedEndpointBinding.wrappedValue = endpointType
            
            // Then
            XCTAssertEqual(vm.selectedEndpoint, endpointType)
        }
    }
    
    // MARK: - test_RecipeViewModel_updateDataStatus_shouldReturnDataStatus
    /// Tests if the `updateDataStatus` method updates the data status correctly.
    ///
    /// This test verifies that when the `updateDataStatus` method is called with different data status types,
    /// the `currentDataStatus` property in the view model reflects the correct value.
    func test_RecipeViewModel_updateDataStatus_shouldReturnDataStatus() {
        // Given
        let dataStatusTypesArray: [RecipeDataStatusTypes] = RecipeDataStatusTypes.allCases
        
        // When
        for dataStatusType in dataStatusTypesArray {
            vm.updateDataStatus(dataStatusType)
            
            // Then
            XCTAssertEqual(vm.currentDataStatus, dataStatusType)
        }
    }
    
    // MARK: - test_RecipeViewModel_updateRecipesArray_shouldReturnRecipesArray
    /// Tests if the `updateRecipesArray` method updates the recipes array correctly.
    ///
    /// This test verifies that when the `updateRecipesArray` method is called with different arrays of recipes,
    /// the `recipesArray` property in the view model reflects the correct value.
    func test_RecipeViewModel_updateRecipesArray_shouldReturnRecipesArray() {
        // Given
        let mockRecipesArray: [RecipeModel] = Array(repeating: .mockObject, count: 5)
        let emptyArray: [RecipeModel] = []
        let arraysOfArray: [[RecipeModel]] = [mockRecipesArray, emptyArray]
        
        // When
        for array in arraysOfArray {
            vm.updateRecipesArray(array)
            
            // Then
            XCTAssertEqual(vm.recipesArray, array)
        }
    }
    
    // MARK: - test_RecipeViewModel_updateMutableRecipesArray_shouldReturnMutableRecipesArray
    /// Tests if the `updateMutableRecipesArray` method updates the mutable recipes array correctly.
    ///
    /// This test verifies that when the `updateMutableRecipesArray` method is called with different arrays of recipes,
    /// the `mutableRecipesArray` property in the view model reflects the correct value.
    func test_RecipeViewModel_updateMutableRecipesArray_shouldReturnMutableRecipesArray() {
        // Given
        let mockRecipesArray: [RecipeModel] = Array(repeating: .mockObject, count: 5)
        let emptyArray: [RecipeModel] = []
        let arraysOfArray: [[RecipeModel]] = [mockRecipesArray, emptyArray]
        
        // When
        for array in arraysOfArray {
            vm.updateMutableRecipesArray(array)
            
            // Then
            XCTAssertEqual(vm.mutableRecipesArray, array)
        }
    }
    
    // MARK: - test_RecipeViewModel_emptyRecipesAndMutableRecipesArray_shouldReturnEmptyArrays
    /// Tests if the `emptyRecipesAndMutableRecipesArray` method clears the recipes arrays.
    ///
    /// This test verifies that when the `emptyRecipesAndMutableRecipesArray` method is called,
    /// the `recipesArray` and `mutableRecipesArray` properties in the view model are cleared.
    func test_RecipeViewModel_emptyRecipesAndMutableRecipesArray_shouldReturnEmptyArrays() {
        // Given
        let mockRecipesArray: [RecipeModel] = Array(repeating: .mockObject, count: 5)
        vm.updateRecipesArray(mockRecipesArray)
        vm.updateMutableRecipesArray(mockRecipesArray)
        XCTAssertFalse(vm.recipesArray.isEmpty)
        XCTAssertFalse(vm.mutableRecipesArray.isEmpty)
        
        // When
        vm.emptyRecipesAndMutableRecipesArray()
        
        // Then
        XCTAssertTrue(vm.recipesArray.isEmpty)
        XCTAssertTrue(vm.mutableRecipesArray.isEmpty)
    }
    
    // MARK: - test_RecipeViewModel_fetchAndUpdateRecipes_shouldReturnExpectedArrays
    /// Tests if the `fetchAndUpdateRecipes` method fetches and updates the recipes arrays correctly for different endpoint models.
    ///
    /// This test verifies that when the `fetchAndUpdateRecipes` method is called with different endpoint models,
    /// the `recipesArray`, `mutableRecipesArray`, and `currentDataStatus` properties in the view model are updated
    /// as expected based on the endpoint model.
    func test_RecipeViewModel_fetchAndUpdateRecipes_shouldReturnExpectedArrays() async {
        // Given
        let endpointTypesArray: [RecipeEndpointTypes] = RecipeEndpointTypes.allCases
        let permutationsArray: [[RecipeEndpointTypes]] = endpointTypesArray.generatePermutations()
        
        // When
        for permutation in permutationsArray {
            for endpoint in permutation  {
                // Then
                switch endpoint {
                case .all:
                    do {
                        try await vm.fetchAndUpdateRecipes(endpoint: endpoint)
                    } catch {
                        XCTFail("Expected successful fetch and update, but got an error: \(error)")
                    }
                    XCTAssertFalse(vm.recipesArray.isEmpty)
                    XCTAssertFalse(vm.mutableRecipesArray.isEmpty)
                    XCTAssertEqual(vm.currentDataStatus, .none)
                case .malformed:
                    do {
                        try await vm.fetchAndUpdateRecipes(endpoint: endpoint)
                        XCTFail("Expected successful failure but got no error.")
                    } catch {
                        XCTAssertTrue(vm.recipesArray.isEmpty)
                        XCTAssertTrue(vm.mutableRecipesArray.isEmpty)
                        XCTAssertEqual(vm.currentDataStatus, .malformed)
                    }
                case .empty:
                    do {
                        try await vm.fetchAndUpdateRecipes(endpoint: endpoint)
                    } catch {
                        XCTFail("Expected successful fetch and update, but got an error: \(error)")
                    }
                    XCTAssertTrue(vm.recipesArray.isEmpty)
                    XCTAssertTrue(vm.mutableRecipesArray.isEmpty)
                    XCTAssertEqual(vm.currentDataStatus, .emptyData)
                }
            }
        }
    }
}

extension RecipeViewModel_Tests {
    // MARK: REUSABLE FUNCTIONS
    
    // MARK: - initialize
    
    /// Initializes the necessary components for testing.
    ///
    /// This function sets up the mock service and initializes the view model and sorting manager before each test case.
    private func initialize() {
        let mockRecipeAPIService: RecipeServiceProtocol = MockRecipeAPIService()
        self.vm = .init(recipeService: mockRecipeAPIService)
        
        XCTAssertEqual("\(vm.recipeService)", "\(mockRecipeAPIService)")
    }
}
