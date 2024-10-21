//
//  RecipeAPIService.swift
//  FetchBook
//
//  Created by Mr. Kavinda Dilshan on 2024-10-06.
//

import Foundation

// Real API service that conforms to RecipeServiceProtocol
actor RecipeAPIService: RecipeServiceProtocol {
    
    // MARK: - FUNCTIONS
    
    /// Fetches raw data from a specified URL.
    ///
    /// This asynchronous function performs a network request to retrieve raw data from the given URL.
    /// It constructs a URL request with a cache policy to ignore cached data and a timeout interval.
    ///
    /// - Parameter url: The URL to fetch data from.
    /// - Throws: `URLError` if the network request fails.
    /// - Returns: Raw `Data` fetched from the specified URL.
    func fetchData(from url: URL) async throws -> Data {
        let request: URLRequest = .init(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 10)
        let (data, _) = try await URLSession.shared.data(for: request)
        return data
    }
    
    /// Fetches recipe data from the specified API endpoint.
    ///
    /// This asynchronous function retrieves recipe data from a given endpoint defined by the `RecipeEndpoints` enum.
    /// It constructs a URL from the endpoint, configures a URL request, and performs a network request.
    /// The response is then decoded into a `RecipesModel` object.
    ///
    /// - Parameter endpoint: The specific endpoint to fetch data from, defined by the `RecipeEndpointModel`.
    /// - Throws: `URLError` if the URL is invalid, or if the network request fails or the response cannot be decoded.
    /// - Returns: A `RecipesModel` containing the recipes fetched from the specified API endpoint.
    func fetchRecipeData(from endpoint: RecipeEndpointModel) async throws -> RecipesModel {
        let urlString = endpoint.urlString
        guard let url = URL(string: urlString) else {
            throw RecipeServiceErrors.invalidURL(urlString)
        }
        do {
            let recipes: RecipesModel = try await self.fetchJSON(from: url, type: RecipesModel.self)
            return recipes
        } catch let error as DecodingError {
            throw RecipeServiceErrors.decodingError(error)
        } catch {
            throw RecipeServiceErrors.networkError(error)
        }
    }
}
