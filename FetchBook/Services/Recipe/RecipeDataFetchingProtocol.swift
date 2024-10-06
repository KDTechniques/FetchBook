//
//  RecipeDataFetchingProtocol.swift
//  FetchBook
//
//  Created by Mr. Kavinda Dilshan on 2024-10-06.
//

import Foundation

protocol RecipeDataFetching {
    // MARK: - FUNCTIONS
    func fetchRecipeData(from endpoint: RecipeViewModel.Endpoints) async throws -> RecipesModel
}
