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
    
    // MARK: FUNCTIONS
    
    // MARK: - setUpWithError
    override func setUpWithError() throws {
        let mockRecipeAPIService: RecipeServiceProtocol = MockRecipeAPIService()
        self.vm = .init(recipeService: mockRecipeAPIService)
        self.sortingManager = .init(recipeVM: vm)
    }
    
    // MARK: - tearDownWithError
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    
}
