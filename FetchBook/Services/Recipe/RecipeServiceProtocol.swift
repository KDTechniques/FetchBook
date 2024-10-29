//
//  RecipeServiceProtocol.swift
//  FetchBook
//
//  Created by Mr. Kavinda Dilshan on 2024-10-06.
//

import Foundation

// Protocol defining a service for fetching recipe data
protocol RecipeServiceProtocol: NetworkServiceProtocol {
    /// Fetches recipe data from a specified API endpoint.
    ///
    /// This asynchronous function retrieves recipe data from a given endpoint defined by the `RecipeEndpointModel`.
    ///
    /// - Parameter endpoint: The specific endpoint to fetch data from, defined by the `RecipeEndpointModel`.
    /// - Throws: An error if the network request fails or if the data cannot be decoded.
    /// - Returns: A `RecipesModel` containing the recipes fetched from the specified API endpoint.
    func fetchRecipeData(from endpoint: RecipeEndpointModel) async throws -> RecipesModel
}
