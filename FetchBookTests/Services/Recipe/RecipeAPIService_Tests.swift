//
//  RecipeAPIService_Tests.swift
//  FetchBookTests
//
//  Created by Mr. Kavinda Dilshan on 2024-11-01.
//

import XCTest
@testable import FetchBook

@MainActor
final class RecipeAPIService_Tests: XCTestCase {
    // MARK: - PROPERTIES
    let recipeAPIService: RecipeServiceProtocol = RecipeAPIService()
    
    // MARK: FUNCTIONS
    
    // MARK: - setUpWithError
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    // MARK: - tearDownWithError
    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }
    
    // MARK: UNIT TESTS
    
    // MARK: fetchData
    
    // MARK: - test_RecipeAPIService_fetchData_shouldReturnData
    /// Tests if the `fetchData` method returns data for all valid endpoints.
    ///
    /// This test verifies that when the `fetchData` method is called with valid URLs, it successfully retrieves data without any errors.
    func test_RecipeAPIService_fetchData_shouldReturnData() async {
        // Given
        let endpointsArray: [RecipeEndpointTypes] = RecipeEndpointTypes.allCases
        
        // When
        for endpoint in endpointsArray {
            guard let url: URL = .init(string: endpoint.urlString) else {
                XCTFail("Expected a valid URL, but it's nil.")
                return
            }
            
            do {
                let data: Data = try await recipeAPIService.fetchData(from: url)
                
                // Then
                XCTAssertFalse(data.isEmpty)
            } catch {
                XCTFail("Expected successful fetch, but got an error: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - test_RecipeAPIService_fetchData_shouldThrow
    /// Tests if the `fetchData` method throws an error for an invalid URL.
    ///
    /// This test verifies that when the `fetchData` method is called with an invalid URL, it correctly throws an error and does not return any data.
    func test_RecipeAPIService_fetchData_shouldThrow() async {
        // Given
        var data: Data?
        guard let url: URL = .init(string: "https://!@#$%^&*()_+") else {
            XCTFail("Expected valid URL, but got an invalid url.")
            return
        }
        
        do {
            // When
            let tempData: Data = try await recipeAPIService.fetchData(from: url)
            data = tempData
            
            // Then
            XCTAssertThrowsError("Successfully throw an error.")
        } catch {
            // Then
            XCTAssertEqual(data, nil)
        }
    }
    
    // MARK: fetchRecipeData
    
    // MARK: - test_RecipeAPIService_fetchRecipeData_shouldReturnRecipesModel
    /// Tests if the `fetchRecipeData` method returns a `RecipesModel` for valid endpoints.
    ///
    /// This test verifies that when the `fetchRecipeData` method is called with valid endpoints, it successfully retrieves and parses the data into a `RecipesModel` object.
    func test_RecipeAPIService_fetchRecipeData_shouldReturnRecipesModel() async {
        // Given
        let endpointsArray: [RecipeEndpointTypes] = [.all, .empty]
        
        // When
        for endpoint in endpointsArray {
            do {
                let recipes: RecipesModel = try await recipeAPIService.fetchRecipeData(from: endpoint)
                
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
    
    // MARK: - test_RecipeAPIService_fetchRecipeData_shouldThrow
    /// Tests if the `fetchRecipeData` method throws an error for a malformed endpoint.
    ///
    /// This test verifies that when the `fetchRecipeData` method is called with a malformed endpoint, it correctly throws an error and does not return any recipes.
    func test_RecipeAPIService_fetchRecipeData_shouldThrow() async {
        // Given
        let endpoint: RecipeEndpointTypes = .malformed
        var recipes: [RecipeModel] = []
        
        // Then
        do {
            let tempRecipes: RecipesModel = try await recipeAPIService.fetchRecipeData(from: endpoint)
            recipes = tempRecipes.recipes
            XCTAssertThrowsError("Successfully throw an error.")
        } catch {
            XCTAssertTrue(recipes.isEmpty)
        }
    }
}
