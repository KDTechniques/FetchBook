////  RecipeFilteringManager_Tests.swift
//  FetchBookTests
//
//  Created by Mr. Kavinda Dilshan on 2024-10-31.
//
import XCTest
@testable import FetchBook

@MainActor
final class RecipeFilteringManager_Tests: XCTestCase {
    
    // MARK: - PROPERTIES
    var vm: RecipeViewModel!
    
    /// A mock array of `RecipeModel` objects used for testing sorting functionality.
    let mockRecipesArray: [RecipeModel] = [
        .init(id: UUID().uuidString, name: "Honey Yogurt Cheesecake", cuisine: "", photoURLLargeString: "", thumbnailURLString: "", blogPostURLString: nil, youtubeURLString: nil),
        .init(id: UUID().uuidString, name: "Battenberg Cake", cuisine: "", photoURLLargeString: "", thumbnailURLString: "", blogPostURLString: nil, youtubeURLString: nil),
        .init(id: UUID().uuidString, name: "Apam Balik", cuisine: "", photoURLLargeString: "", thumbnailURLString: "", blogPostURLString: nil, youtubeURLString: nil),
        .init(id: UUID().uuidString, name: "Krispy Kreme Donut", cuisine: "", photoURLLargeString: "", thumbnailURLString: "", blogPostURLString: nil, youtubeURLString: nil)
    ]
    
    /// Enum representing text case types for testing purposes.
    enum TextCaseTypes: CaseIterable {
        case lowercased, uppercased, capitalized
    }
    
    // MARK: FUNCTIONS
    
    // MARK: - setUpWithError
    /// Sets up the test environment before each test method in the class is called.
    /// Initializes the `RecipeViewModel`, `RecipeSortingManager`, and `RecipeFilteringManager` instances.
    override func setUpWithError() throws {
        self.initialize()
    }
    
    // MARK: - tearDownWithError
    /// Cleans up the test environment after each test method in the class is called.
    /// Use this method to release any resources that were created in `setUpWithError`.
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // MARK: UNIT TESTS
    
    // MARK: - test_RecipeFilteringManager_Tests_recipeSearchTextSubscriber_shouldReturnFilteredRecipesArray
    /// Tests if the `recipeSearchTextSubscriber` returns a filtered array based on different text cases.
    ///
    /// This test verifies that when the `recipeSearchText` is set to various text cases, the `recipeSearchTextSubscriber`
    /// correctly filters the recipes array and updates the view model properties.
    func test_RecipeFilteringManager_Tests_recipeSearchTextSubscriber_shouldReturnFilteredRecipesArray() async {
        // Given
        let textCases: [TextCaseTypes] = TextCaseTypes.allCases
        self.initializeRecipesArraysWithMockData()
        
        // When
        for name in mockRecipesArray.map({ $0.name }) {
            for textCase in textCases {
                var caseModifiedText: String {
                    switch textCase {
                    case .lowercased:
                        return name.lowercased()
                    case .uppercased:
                        return name.uppercased()
                    case .capitalized:
                        return name.capitalized
                    }
                }
                vm.recipeSearchTextBinding.wrappedValue = caseModifiedText
                do {
                    // Introduce a delay to allow the search text to be observed.
                    try await Task.sleep(nanoseconds: 300_000_000)
                } catch {
                    XCTFail("Expected successful delay, but got an error: \(error)")
                }
                
                // Then
                XCTAssertEqual(vm.recipesArray, self.mockRecipesArray)
                XCTAssertFalse(vm.mutableRecipesArray.isEmpty)
                XCTAssertEqual(vm.mutableRecipesArray.count, 1)
                XCTAssertEqual(vm.mutableRecipesArray.first?.name.lowercased(), vm.recipeSearchText.lowercased())
                XCTAssertNotEqual(vm.recipesArray, vm.mutableRecipesArray)
                XCTAssertEqual(vm.currentDataStatus, .none)
            }
        }
    }
    
    // MARK: - test_RecipeFilteringManager_Tests_recipeSearchTextSubscriber_shouldNotReturnEmptyArray
    /// Tests if the `recipeSearchTextSubscriber` does not return an empty array when the search text is empty.
    ///
    /// This test verifies that when the `recipeSearchText` is set to an empty string, the `recipeSearchTextSubscriber`
    /// correctly updates the view model properties without returning an empty array.
    func test_RecipeFilteringManager_Tests_recipeSearchTextSubscriber_shouldNotReturnEmptyArray() async {
        // Given
        self.initializeRecipesArraysWithMockData()
        
        // When
        vm.recipeSearchTextBinding.wrappedValue = ""
        do {
            // Introduce a delay to allow the search text to be observed.
            try await Task.sleep(nanoseconds: 300_000_000)
        } catch {
            XCTFail("Expected successful delay, but got an error: \(error)")
        }
        
        // Then
        XCTAssertEqual(vm.recipeSearchText, "")
        XCTAssertFalse(vm.mutableRecipesArray.isEmpty)
        XCTAssertEqual(vm.recipesArray, vm.mutableRecipesArray)
        XCTAssertEqual(vm.currentDataStatus, .none)
    }
    
    // MARK: - test_RecipeFilteringManager_Tests_recipeSearchTextSubscriber_shouldReturnEmptyArray
    /// Tests if the `recipeSearchTextSubscriber` returns an empty array when the search text is invalid.
    ///
    /// This test verifies that when the `recipeSearchText` is set to an invalid string, the `recipeSearchTextSubscriber`
    /// correctly updates the view model properties and returns an empty array.
    func test_RecipeFilteringManager_Tests_recipeSearchTextSubscriber_shouldReturnEmptyArray() async {
        // Given
        let invalidText: String = "!@#$%^&*()_+"
        self.initializeRecipesArraysWithMockData()
        
        // When
        vm.recipeSearchTextBinding.wrappedValue = invalidText
        do {
            // Introduce a delay to allow the search text to be observed.
            try await Task.sleep(nanoseconds: 300_000_000)
        } catch {
            XCTFail("Expected successful delay, but got an error: \(error)")
        }
        
        // Then
        XCTAssertTrue(vm.mutableRecipesArray.isEmpty)
        XCTAssertNotEqual(vm.recipesArray, vm.mutableRecipesArray)
        XCTAssertEqual(vm.currentDataStatus, .emptyResult)
    }
}

extension RecipeFilteringManager_Tests {
    
    // MARK: - REUSABLE FUNCTIONS
    
    // MARK: - initialize
    
    /// Initializes the `RecipeViewModel` instance.
    private func initialize() {
        let mockRecipeAPIService: RecipeServiceProtocol = MockRecipeAPIService()
        self.vm = .init(recipeService: mockRecipeAPIService)
        
        XCTAssertEqual("\(vm.recipeService)", "\(mockRecipeAPIService)")
    }
    
    // MARK: - initializeRecipesArraysWithMockData
    
    /// Initializes the recipes arrays with mock data.
    ///
    /// This function updates the view model's `recipesArray` and `mutableRecipesArray` properties with mock data
    private func initializeRecipesArraysWithMockData() {
        vm.updateRecipesArray(self.mockRecipesArray)
        vm.updateMutableRecipesArray(self.mockRecipesArray)
    }
}
