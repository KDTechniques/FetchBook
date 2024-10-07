//
//  MockRecipeAPIService.swift
//  FetchBook
//
//  Created by Mr. Kavinda Dilshan on 2024-10-06.
//

import Foundation

// Mock API service used for unit testing, also conforms to RecipeDataFetching
class MockRecipeAPIService: RecipeDataFetching {
    // MARK: - FUNCTIONS
    
    // MARK: - fetchRecipeData
    /// Fetches recipe data from a mock API endpoint.
    ///
    /// This asynchronous function simulates fetching recipe data by converting a predefined JSON string into
    /// a `RecipesModel` object. It handles different endpoint scenarios to provide the appropriate response:
    /// - For the `.all` endpoint, it returns a populated `RecipesModel` with mock recipes.
    /// - For the `.malformed` endpoint, it throws a `URLError` to simulate a malformed response.
    /// - For the `.empty` endpoint, it returns an empty `RecipesModel`.
    ///
    /// - Parameter endpoint: The specific endpoint to fetch data from, defined by the `RecipeEndpointModel`.
    /// - Throws: `URLError` if the JSON string cannot be parsed or if the endpoint is malformed.
    /// - Returns: A `RecipesModel` containing the recipes fetched from the mock data.
    func fetchRecipeData(from endpoint: RecipeEndpointModel) async throws -> RecipesModel {
        var mockJSONString: String { """
        {
            "recipes": [
                {
                    "cuisine": "French",
                    "name": "Pear Tarte Tatin",
                    "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/376f3377-c481-43cf-bcc6-c0befd612552/large.jpg",
                    "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/376f3377-c481-43cf-bcc6-c0befd612552/small.jpg",
                    "source_url": "https://www.bbcgoodfood.com/recipes/4778/pear-tarte-tatin",
                    "uuid": "8925bfec-3ef5-4c56-a9d1-80e42654e0bf",
                    "youtube_url": "https://www.youtube.com/watch?v=8U1tKWKDeWA"
                },
                {
                    "cuisine": "British",
                    "name": "Chelsea Buns",
                    "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/4aecd46e-e419-49ec-8888-246b3cc0cc94/large.jpg",
                    "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/4aecd46e-e419-49ec-8888-246b3cc0cc94/small.jpg",
                    "source_url": "https://www.bbc.co.uk/food/recipes/chelsea_buns_95015",
                    "uuid": "7fc217a9-5566-4bf1-b1ce-13bc9e3f2b1a",
                    "youtube_url": ""
                },
                {
                    "cuisine": "Malaysian",
                    "name": "Apam Balik",
                    "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
                    "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
                    "source_url": "",
                    "uuid": "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
                    "youtube_url": "https://www.youtube.com/watch?v=6R8ffRRJcrg"
                },
                {
                    "cuisine": "British",
                    "name": "Treacle Tart",
                    "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/dac510db-fa7f-4bf1-af61-706a9c960455/large.jpg",
                    "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/dac510db-fa7f-4bf1-af61-706a9c960455/small.jpg",
                    "source_url": "https://www.bbc.co.uk/food/recipes/mary_berrys_treacle_tart_28524",
                    "uuid": "55dcfb29-fe1b-4c28-8d0b-361497ae27f7",
                    "youtube_url": "https://www.youtube.com/watch?v=YMmgKCNcqwI"
                }
            ]
        }
        """ }
        
        
        // Simulate a JSON response by converting the string to Data
        guard let data = mockJSONString.data(using: .utf8) else {
            throw URLError(.cannotParseResponse)
        }
        
        // Decode the JSON string into your RecipesModel
        let recipesResponse = try JSONDecoder().decode(RecipesModel.self, from: data)
        
        // Depending on the endpoint type, return the mock data or simulate errors
        switch endpoint.type {
        case .all:
            return recipesResponse
        case .malformed:
            throw URLError(.cannotParseResponse) // Simulate a malformed response
        case .empty:
            return RecipesModel(recipes: []) // Simulate empty response
        }
    }
}
