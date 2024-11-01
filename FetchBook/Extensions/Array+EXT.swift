//
//  Array+EXT.swift
//  FetchBook
//
//  Created by Mr. Kavinda Dilshan on 2024-10-29.
//

import Foundation

extension Array {
    // MARK: - generatePermutations
    /// Generates all unique permutations of the elements in the conforming array.
    ///
    /// This function uses recursion and Swift's high-order functions to generate all unique permutations
    /// of the array elements.
    ///
    /// - Returns: An array containing all unique permutations of the input array.
    func generatePermutations() -> [Self] {
        // Base case: if the array has 0 or 1 elements, return the array as the only permutation.
        guard count > 1 else { return [self] }
        
        // Use flatMap to generate all permutations by fixing each element at the first position
        // and recursively generating permutations for the remaining elements.
        return indices.flatMap { index in
            // Create a mutable copy of the array and remove the element at the current index.
            var remainingElements: Self = self
            let element: Self.Element = remainingElements.remove(at: index)
            
            // Recursively generate permutations for the remaining elements and prepend the fixed element.
            return remainingElements.generatePermutations().map { [element] + $0 }
        }
    }
}
