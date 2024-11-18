//
//  ContentView.swift
//  FetchBook
//
//  Created by Mr. Kavinda Dilshan on 2024-10-06.
//

import SwiftUI

struct ContentView: View {
    // MARK: - INITIAL PROPERTIES
    @StateObject private var recipeVM: RecipeViewModel
    
    // MARK: - INITIALIZER
    init(recipeService: RecipeServiceProtocol) {
        _recipeVM = StateObject(wrappedValue: RecipeViewModel(recipeService: recipeService))
    }
    
    // MARK: - PRIVATE PROPERTIES
    @State private var selectedTab: TabBarTypes = .recipe
    
    // MARK: - BODY
    var body: some View {
        TabView(selection: $selectedTab) {
            recipes
            debug
        }
    }
}

// MARK: - PREVIEWS
#Preview("ContentView - MockRecipeAPIService") {
    ContentView(recipeService: MockRecipeAPIService())
}

#Preview("ContentView - RecipeAPIService") {
    ContentView(recipeService: RecipeAPIService())
}

extension ContentView {
    // MARK: - recipes
    private var recipes: some View {
        RecipesView(vm: recipeVM)
            .tabItem {
                Label("Recipes", systemImage: "book.fill")
            }
            .tag(TabBarTypes.recipe)
    }
    
    // MARK: - debug
    private var debug: some View {
#if DEBUG
        DebugView(vm: recipeVM)
            .tabItem {
                Label("Debug", systemImage: "wrench.and.screwdriver.fill")
            }
            .tag(TabBarTypes.debug)
#endif
    }
}
