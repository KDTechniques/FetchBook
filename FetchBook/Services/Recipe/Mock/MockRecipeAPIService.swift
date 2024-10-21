//
//  MockRecipeAPIService.swift
//  FetchBook
//
//  Created by Mr. Kavinda Dilshan on 2024-10-06.
//

import Foundation

// Mock API service used for unit testing, conforms to RecipeServiceProtocol
actor MockRecipeAPIService: RecipeServiceProtocol {
    
    // MARK: - FUNCTIONS
    
    // MARK: - fetchData
    
    /// Fetches data from a given URL.
    ///
    /// This asynchronous function reads data from the specified URL. It's used in unit testing to simulate
    /// fetching data from a file or other sources.
    ///
    /// - Parameter url: The URL to fetch data from.
    /// - Throws: `URLError` if the data cannot be read from the URL.
    /// - Returns: Data fetched from the specified URL.
    func fetchData(from url: URL) async throws -> Data {
        guard let data = try? Data(contentsOf: url) else {
            throw RecipeServiceErrors.fileNotFound(url.absoluteString)
        }
        return data
    }
    
    // MARK: - fetchRecipeData
    
    /// Fetches recipe data from a mock API endpoint.
    ///
    /// This asynchronous function simulates fetching recipe data by loading it from a JSON file in the app bundle.
    /// It handles different endpoint scenarios to provide the appropriate response:
    /// - For the `.all` endpoint, it returns a populated `RecipesModel` with mock recipes.
    /// - For the `.malformed` endpoint, it throws a `URLError` to simulate a malformed response.
    /// - For the `.empty` endpoint, it returns an empty `RecipesModel`.
    ///
    /// - Parameter endpoint: The specific endpoint to fetch data from, defined by the `RecipeEndpointModel`.
    /// - Throws: `URLError` if the file cannot be read or if the data cannot be parsed.
    /// - Returns: A `RecipesModel` containing the recipes fetched from the mock data.
    func fetchRecipeData(from endpoint: RecipeEndpointModel) async throws -> RecipesModel {
        // Introduce a delay of 2 seconds (2_000_000_000 nanoseconds)
        try await Task.sleep(nanoseconds: 2_000_000_000)
        let fileName: String = getMockJsonFilename(for: endpoint)
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else {
            throw RecipeServiceErrors.fileNotFound(fileName+".json")
        }
        let url: URL = .init(fileURLWithPath: path)
        let recipes: RecipesModel = try await self.fetchJSON(from: url, type: RecipesModel.self)
        return recipes
    }
    
    // MARK: - getMockJsonFilename
    
    /// Retrieves the filename of the mock JSON data based on the endpoint type.
    ///
    /// This function returns the name of the mock JSON file corresponding to the specified endpoint type.
    /// The filenames are used to locate the mock data files in the app bundle.
    ///
    /// - Parameter endpoint: The specific endpoint to fetch data from.
    /// - Returns: A mock JSON filename corresponding to the endpoint type.
    private func getMockJsonFilename(for endpoint: RecipeEndpointModel) -> String {
        switch endpoint.type {
        case .all:
            return "recipes"
        case .malformed:
            return "recipes-malformed"
        case .empty:
            return "recipes-empty"
        }
    }
}
