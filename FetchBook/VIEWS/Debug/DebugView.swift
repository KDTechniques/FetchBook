//
//  DebugView.swift
//  FetchBook
//
//  Created by Mr. Kavinda Dilshan on 2024-10-07.
//

import SwiftUI
import SDWebImageSwiftUI

struct DebugView: View {
    // MARK: - PROEPRTIES
    @ObservedObject private var recipeVM: RecipeViewModel
    
    // MARK: - INITIALIZER
    init(vm: RecipeViewModel) {
        _recipeVM = ObservedObject(wrappedValue: vm)
    }
    
    // MARK: - BODY
    var body: some View {
        NavigationStack {
            Form {
                endpoint
                imageCache
            }
            .navigationTitle("Debug")
        }
    }
}

// MARK: - PREVIEWS
#Preview("DebugView") {
    DebugView(vm: .init(recipeService: MockRecipeAPIService()))
}

extension DebugView {
    // MARK: - endpoint
    private var endpoint: some View {
        Section {
            Picker("Recipe Endpoints Picker", selection: $recipeVM.selectedEndpoint) {
                ForEach(RecipeEndpoints.allCases, id: \.self) {
                    Text($0.type.rawValue.capitalized)
                        .tag($0)
                }
            }
            .pickerStyle(.segmented)
        } header: {
            Text("Endpoint")
        } footer: {
            Text("Note: Refresh the list after selecting an endpoint to see the results.")
                .font(.footnote)
        }
    }
    
    // MARK: - imageCache
    private var imageCache: some View {
        Section {
            Button("Clear Image Cache") {
                Helpers.clearImageCache()
            }
        }  footer: {
            Text("Note: Refresh the list after clearing cache from both memory and disk to see the results.")
                .font(.footnote)
        }
    }
}
