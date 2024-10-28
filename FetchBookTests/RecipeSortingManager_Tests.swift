//
//  RecipeSortingManager_Tests.swift
//  FetchBookTests
//
//  Created by Mr. Kavinda Dilshan on 2024-10-28.
//

import XCTest
@testable import FetchBook

@MainActor
final class RecipeSortingManager_Tests: XCTestCase {
    // MARK: PROPERTIES
    var vm: RecipeViewModel!
    var sortingManager: RecipeSortingManager!
    
    /// A mock array of `RecipeModel` objects used for testing sorting functionality.
    let mockRecipesArray: [RecipeModel] = [
        .init(id: UUID().uuidString, name: "Honey Yogurt Cheesecake", cuisine: "", photoURLLargeString: "", thumbnailURLString: "", blogPostURLString: nil, youtubeURLString: nil),
        .init(id: UUID().uuidString, name: "Battenberg Cake", cuisine: "", photoURLLargeString: "", thumbnailURLString: "", blogPostURLString: nil, youtubeURLString: nil),
        .init(id: UUID().uuidString, name: "Apam Balik", cuisine: "", photoURLLargeString: "", thumbnailURLString: "", blogPostURLString: nil, youtubeURLString: nil),
        .init(id: UUID().uuidString, name: "Krispy Kreme Donut", cuisine: "", photoURLLargeString: "", thumbnailURLString: "", blogPostURLString: nil, youtubeURLString: nil)
    ]
    
    /// The expected first element in the array when sorted in ascending order.
    let ascendingFirstElement: String = "Apam Balik"
    
    /// The expected last element in the array when sorted in ascending order.
    let ascendingLastElement: String = "Krispy Kreme Donut"
    
    /// The expected first element in the array when sorted in descending order.
    var descendingFirstElement: String {
        return ascendingLastElement
    }
    
    /// The expected last element in the array when sorted in descending order.
    var descendingLastElement: String {
        return ascendingFirstElement
    }
    
    /// The expected first element in the array when no sorting is applied.
    var defaultFirstElement: String {
        return mockRecipesArray.first!.name
    }
    
    /// The expected last element in the array when no sorting is applied.
    var defaultLastElement: String {
        return mockRecipesArray.last!.name
    }
    
    // MARK: FUNCTIONS
    
    // MARK: - setUpWithError
    override func setUpWithError() throws {
        self.initialize()
    }
    
    // MARK: - tearDownWithError
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // MARK: Unit Tests
    
    // MARK: sortRecipes()
    
    // MARK: - test_RecipeSortingManager_sortRecipes_shouldReturnAscendingArray
    /// Tests if `sortRecipes` returns an array sorted in ascending order.
    ///
    /// This test verifies that the sorting manager correctly sorts the recipes array in ascending order.
    func test_RecipeSortingManager_sortRecipes_shouldReturnAscendingArray() async {
        // Given, When & Then
        await self.checkSortedArray(type: .ascending, firstElement: self.ascendingFirstElement, lastElement: self.ascendingLastElement)
    }
    
    // MARK: - test_RecipeSortingManager_sortRecipes_shouldReturnAscendingArray
    /// Tests if `sortRecipes` returns an array sorted in descending order.
    ///
    /// This test verifies that the sorting manager correctly sorts the recipes array in descending order.
    func test_RecipeSortingManager_sortRecipes_shouldReturnDescendingArray() async {
        // Given, When & Then
        await self.checkSortedArray(type: .descending, firstElement: self.descendingFirstElement, lastElement: self.descendingLastElement)
    }
    
    // MARK: - test_RecipeSortingManager_sortRecipes_shouldReturnAscendingArray
    /// Tests if `sortRecipes` returns the default array.
    ///
    /// This test verifies that the sorting manager returns the default order of the recipes array when no sorting is applied.
    func test_RecipeSortingManager_sortRecipes_shouldReturnDefaultArray() async {
        // Given, When & Then
        await self.checkSortedArray(type: .none, firstElement: self.defaultFirstElement, lastElement: self.defaultLastElement)
    }
    
    // MARK: - test_RecipeSortingManager_sortRecipes_shouldPassAllPossiblePermutations
    /// Tests all permutations of `RecipeSortTypes` to ensure `sortRecipes` works correctly.
    ///
    /// This test verifies that the `sortRecipes` method handles all permutations of the sorting types correctly.
    /// This simulates a real-life scenario where a user sort recipes over and over again at the same time.
    func test_RecipeSortingManager_sortRecipes_shouldPassAllPossibleSortingPermutations() async {
        // Given
        let sortTypes: [RecipeSortTypes] = RecipeSortTypes.allCases
        let permutations: [[RecipeSortTypes]] = sortTypes.generatePermutations()
        
        // Given, When & Then
        for sortTypes in permutations {
            for sortType in sortTypes {
                switch sortType {
                case .ascending:
                    await checkSortedArray(type: sortType, firstElement: ascendingFirstElement, lastElement: ascendingLastElement)
                case .descending:
                    await checkSortedArray(type: sortType, firstElement: descendingFirstElement, lastElement: descendingLastElement)
                case .none:
                    await checkSortedArray(type: sortType, firstElement: defaultFirstElement, lastElement: defaultLastElement)
                }
            }
        }
    }
    
    
    
    
    
    
}

extension RecipeSortingManager_Tests {
    // MARK: REUSABLE FUNCTIONS
    
    // MARK: - initialize
    /// Initializes the necessary components for testing.
    ///
    /// This function sets up the mock service and initializes the view model and sorting manager before each test case.
    private func initialize() {
        let mockRecipeAPIService: RecipeServiceProtocol = MockRecipeAPIService()
        self.vm = .init(recipeService: mockRecipeAPIService)
        self.sortingManager = .init(recipeVM: vm)
    }
    
    // MARK: - checkSortedArray
    /// Checks if the sorted array meets the expected criteria.
    ///
    /// This function verifies that the sorted array has the expected first and last elements.
    ///
    /// - Parameters:
    ///   - type: The type of sorting to be applied.
    ///   - firstElement: The expected first element in the sorted array.
    ///   - lastElement: The expected last element in the sorted array.
    private func checkSortedArray(type: RecipeSortTypes, firstElement: String, lastElement: String) async {
        // Given
        vm.updateRecipesArray(self.mockRecipesArray)
        
        // When
        let sortedRecipesArray: [RecipeModel] = await sortingManager.sortRecipes(type: type)
        
        // Then
        XCTAssertFalse(sortedRecipesArray.isEmpty)
        XCTAssertEqual(sortedRecipesArray.first?.name, firstElement)
        XCTAssertEqual(sortedRecipesArray.last?.name, lastElement)
    }
}
