//
//  ContentView.swift
//  FetchBook
//
//  Created by Mr. Kavinda Dilshan on 2024-10-06.
//

import SwiftUI

struct ContentView: View {
    // MARK: - PROPERTIES
    @StateObject private var recipeVM: RecipeViewModel
    
    // MARK: - INITIALIZER
    init(recipeService: RecipeDataFetching) {
        _recipeVM = StateObject(wrappedValue: RecipeViewModel(recipeService: recipeService))
    }
    
    // MARK: - PRIVATE PROPERTIES
    @State private var selectedTab: TabBarTypes = .debug
    
    // MARK: - BODY
    var body: some View {
        TabView(selection: $selectedTab) {
            RecipesView(vm: recipeVM)
                .tabItem {  Label("Recipes", systemImage: "book") }
                .tag(TabBarTypes.recipe)
            
            DebugView(vm: recipeVM)
                .tabItem { Label("Debug", systemImage: "wrench.and.screwdriver") }
                .tag(TabBarTypes.debug)
        }
    }
}

// MARK: - PREVIEWS
#Preview("ContentView") {
    ContentView(recipeService: MockRecipeAPIService())
}
