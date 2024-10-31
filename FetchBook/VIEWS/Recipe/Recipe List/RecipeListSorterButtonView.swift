//
//  RecipeListSorterButtonView.swift
//  FetchBook
//
//  Created by Mr. Kavinda Dilshan on 2024-10-06.
//

import SwiftUI

struct RecipeListSorterButtonView: View {
    // MARK: - PROPERTIES
    @ObservedObject var vm: RecipeViewModel
    
    // MARK: - INITIALIZER
    init(vm: RecipeViewModel) {
        self.vm = vm
    }
    
    // MARK: - BODY
    var body: some View {
        Menu {
            Picker(selection: vm.selectedSortTypeBinding, label: Text("Sorting options")) {
                ForEach(RecipeSortTypes.allCases) { option in
                    Text(option.rawValue.capitalized)
                        .tag(option)
                }
            }
        } label: {
            Image(systemName: "arrow.up.arrow.down")
        }
    }
}

// MARK: - PREVIEWS
#Preview("RecipeListSorterButtonView") {
    RecipeListSorterButtonView(vm: .init(recipeService: MockRecipeAPIService()))
}
