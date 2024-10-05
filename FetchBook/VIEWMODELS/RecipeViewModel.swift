//
//  RecipeViewModel.swift
//  FetchBook
//
//  Created by Mr. Kavinda Dilshan on 2024-10-05.
//

import Foundation

final class RecipeViewModel: ObservableObject {
    // MARK: PROPERTIES
    @Published private(set) var recipesArray: [RecipeModel] = []
    
    enum Endpoints: String {
        case all = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
        case malformed = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json"
        case empty = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json"
    }
    
    // MARK: - FUNCTIONS
    
    // MARK: - loadRecipeData
    func fetchRecipeData(endpoint: Endpoints) async throws {
        let urlString = endpoint.rawValue // API endpoint
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        
        let (data, _) = try await URLSession.shared.data(from: url) // Fetch data
        let recipesResponse = try JSONDecoder().decode(RecipesModel.self, from: data) // Decode JSON
        
        DispatchQueue.main.async { [weak self] in
            self?.recipesArray = recipesResponse.recipes // Assign to published property
        }
    }
}
