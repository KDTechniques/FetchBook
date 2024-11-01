//
// MockRecipeAPIService_Tests.swift
//  FetchBookTests
//
//  Created by Mr. Kavinda Dilshan on 2024-11-01.
//

import XCTest
@testable import FetchBook

@MainActor
final class MockRecipeAPIService_Tests: XCTestCase {
    
    // MARK: - PROPERTIES
    let mockRecipeAPIService: RecipeServiceProtocol = MockRecipeAPIService()
    
    // MARK: FUNCTIONS
    
    // MARK: - setUpWithError
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    // MARK: - tearDownWithError
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // MARK: UNIT TESTS
    
    // MARK: fetchData
    
    // MARK: - test_MockRecipeAPIService_fetchData_shouldReturnData
    /// Tests if the `fetchData` method of `MockRecipeAPIService` returns valid data for various file names.
    ///
    /// This test verifies that when the `fetchData` method is called with different file names,
    /// it successfully fetches the corresponding data and the data is not empty.
    ///
    /// - Given: An array of file names.
    /// - When: The `fetchData` method is called with each file name.
    /// - Then: The fetched data is verified to be not empty.
    func test_MockRecipeAPIService_fetchData_shouldReturnData() async {
        // Given
        let fileNamesArray: [String] = ["recipes", "recipes-malformed", "recipes-empty"]
        
        // When
        for fileName in fileNamesArray {
            guard let fileURL: URL = Bundle.main.url(forResource: fileName, withExtension: ".json") else {
                XCTFail("Expected successful file path, but the path is nil.")
                return
            }
            
            do {
                let data: Data = try await mockRecipeAPIService.fetchData(from: fileURL)
                
                // Then
                XCTAssertFalse(data.isEmpty)
            } catch {
                XCTFail("Expected successful Data, but got an error: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - test_MockRecipeAPIService_fetchData_shouldThrow
    
    /// Tests if the `fetchData` method of `MockRecipeAPIService` throws an error for an invalid URL.
    ///
    /// This test verifies that when the `fetchData` method is called with an invalid URL,
    /// it throws an error and the data is nil.
    ///
    /// - Given: An invalid URL.
    /// - When: The `fetchData` method is called with the invalid URL.
    /// - Then: The method throws an error and the data is verified to be nil.
    func test_MockRecipeAPIService_fetchData_shouldThrow() async  {
        // Given
        var data: Data?
        guard let url: URL = .init(string: "https://!@#$%^&*()_+") else {
            XCTFail("Expected valid URL, but go an invalid url.")
            return
        }
        
        do {
            // When
            let tempData: Data = try await mockRecipeAPIService.fetchData(from: url)
            data = tempData
            
            // Then
            XCTAssertThrowsError("Successfully throw an error.")
        } catch {
            // Then
            XCTAssertEqual(data, nil)
        }
    }
    
    // MARK: fetchRecipeData
    
    // MARK: - test_MockRecipeAPIService_fetchRecipeData_shouldReturnRecipesModel
    /// Tests if the `fetchRecipeData` method of `MockRecipeAPIService` returns a `RecipesModel` for various endpoints.
    ///
    /// This test verifies that when the `fetchRecipeData` method is called with different endpoints,
    /// it successfully fetches the corresponding `RecipesModel` and verifies the contents based on the endpoint.
    ///
    /// - Given: An array of endpoint types.
    /// - When: The `fetchRecipeData` method is called with each endpoint.
    /// - Then: The fetched `RecipesModel` is verified based on the endpoint.
    func test_MockRecipeAPIService_fetchRecipeData_shouldReturnRecipesModel() async {
        // Given
        let endpointsArray: [RecipeEndpointTypes] = [.all, .empty]
        
        // When
        for endpoint in endpointsArray {
            do {
                let recipes: RecipesModel = try await mockRecipeAPIService.fetchRecipeData(from: endpoint.endpointModel)
                
                // Then
                switch endpoint {
                case .all:
                    XCTAssertFalse(recipes.recipes.isEmpty)
                case .malformed:
                    break
                case .empty:
                    XCTAssertTrue(recipes.recipes.isEmpty)
                }
            } catch {
                XCTFail("Expected successful fetch, but got an error: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - test_MockRecipeAPIService_fetchRecipeData_shouldThrow
    /// Tests if the `fetchRecipeData` method of `MockRecipeAPIService` throws an error for a malformed endpoint.
    ///
    /// This test verifies that when the `fetchRecipeData` method is called with a malformed endpoint,
    /// it throws an error and the recipes array is empty.
    ///
    /// - Given: A malformed endpoint.
    /// - When: The `fetchRecipeData` method is called with the malformed endpoint.
    /// - Then: The method throws an error and the recipes array is verified to be empty.
    func test_MockRecipeAPIService_fetchRecipeData_shouldThrow() async {
        // Given
        let endpoint: RecipeEndpointTypes = .malformed
        var recipes: [RecipeModel] = []
        
        // Then
        do {
            let tempRecipes: RecipesModel = try await mockRecipeAPIService.fetchRecipeData(from: endpoint.endpointModel)
            recipes = tempRecipes.recipes
            XCTAssertThrowsError("Successfully throw an error.")
        } catch {
            XCTAssertTrue(recipes.isEmpty)
        }
    }
}
