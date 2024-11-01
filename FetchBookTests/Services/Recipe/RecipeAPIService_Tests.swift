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
    let apiService: RecipeServiceProtocol = RecipeAPIService()
    
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
    
    // MARK: - test_RecipeAPIService_fetchData_shouldReturnData
    func test_RecipeAPIService_fetchData_shouldReturnData() async {
        
    }
    
}
