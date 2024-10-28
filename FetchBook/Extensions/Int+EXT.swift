//
//  Int+EXT.swift
//  FetchBook
//
//  Created by Mr. Kavinda Dilshan on 2024-10-27.
//

import Foundation

import Foundation

/// Enum representing errors that can occur while calculating factorial.
enum FactorialError: Error, LocalizedError {
    /// Error for when a negative number is used for factorial calculation.
    case negativeNumber
    
    /// Provides a localized description for each error case.
    var errorDescription: String? {
        switch self {
        case .negativeNumber:
            return "FactorialError: Factorial is not defined for negative numbers."
        }
    }
}

extension Int {
    // MARK: - factorial
    /// Calculates the factorial of the integer.
    ///
    /// This function computes the factorial of the integer using a reduce operation.
    /// It throws an error if the integer is negative, as factorial is not defined for negative numbers.
    ///
    /// - Ex: To find factorial of 3: 3.factorial() =>  6
    ///
    /// - Throws: `FactorialError.negativeNumber` if the integer is negative.
    /// - Returns: The factorial of the integer.
    func factorial() throws -> Self {
        // Ensure the integer is non-negative.
        guard self >= 0 else {
            throw FactorialError.negativeNumber
        }
        
        // Calculate the factorial using a reduce operation.
        return (1...self).reduce(1, *)
    }
}
