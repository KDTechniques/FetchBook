//
//  RecipeAPIService.swift
//  FetchBook
//
//  Created by Mr. Kavinda Dilshan on 2024-10-06.
//

import Foundation

// Real API service that conforms to RecipeDataFetching protocol
actor RecipeAPIService: RecipeDataFetching {
    // MARK: - FUNCTIONS
    
    // MARK: - fetchRecipeData
    /// Fetches recipe data from the specified API endpoint.
    ///
    /// This asynchronous function retrieves recipe data from a given endpoint defined by the `RecipeEndpoints` enum.
    /// It constructs a URL from the endpoint, configures a URL request with a cache policy to ignore cached data,
    /// and performs a network request. The response is then decoded into a `RecipesModel` object.
    ///
    /// The cache policy used is `.reloadIgnoringCacheData`, ensuring that the latest data is fetched directly
    /// from the server, bypassing any locally cached data. The request also has a timeout interval of 10 seconds.
    ///
    /// - Parameter endpoint: The specific endpoint to fetch data from, defined by the `RecipeEndpointModel`.
    /// - Throws: `URLError` if the URL is invalid, or if the network request fails or the response cannot be decoded.
    /// - Returns: A `RecipesModel` containing the recipes fetched from the specified API endpoint.
    func fetchRecipeData(from endpoint: RecipeEndpointModel) async throws -> RecipesModel {
        let urlString = endpoint.urlString
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let request: URLRequest = .init(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 10)
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(RecipesModel.self, from: data)
    }
}
