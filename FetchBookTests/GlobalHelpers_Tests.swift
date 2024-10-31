//
//  GlobalHelpers_Tests.swift
//  FetchBookTests
//
//  Created by Mr. Kavinda Dilshan on 2024-11-01.
//

import XCTest
@testable import FetchBook

@MainActor
final class GlobalHelpers_Tests: XCTestCase {
    // MARK: FUNCTIONS
    
    // MARK; - setUpWithError
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // MARK: UNIT TESTS
    
    // MARK: - test_Helpers_extractYouTubeVideoID_shouldReturnVideoIDString
    /// Tests if the `extractYouTubeVideoID` function correctly extracts the video ID from various YouTube URLs.
    /// This test verifies that when the `extractYouTubeVideoID` function is called with different types of YouTube URLs,
    /// it correctly extracts the video ID or returns nil if the ID cannot be extracted.
    func test_Helpers_extractYouTubeVideoID_shouldReturnVideoIDStringOrNil() {
        // Given
        let mockURLsAndIDsArray: [(urlString: String, expectedID: String?)] = [
            ("https://www.youtube.com/shorts/H1zzapB0EEw", "H1zzapB0EEw"),
            ("https://www.youtube.com/shorts/y3IuoLcoS2c", "y3IuoLcoS2c"),
            ("https://www.youtube.com/watch?v=Qjywrq2gM8o", "Qjywrq2gM8o"),
            ("https://www.youtube.com/watch?v=wSDyiEjhp8k", "wSDyiEjhp8k"),
            ("https://www.youtube.com/watch?v=", nil),
            ("https://www.youtube.com", nil)
        ]
        
        // When
        for item in mockURLsAndIDsArray {
            let extractedID: String? = Helpers.extractYouTubeVideoID(from: item.urlString)
            
            // Then
            XCTAssertEqual(extractedID, item.expectedID)
        }
    }
}
