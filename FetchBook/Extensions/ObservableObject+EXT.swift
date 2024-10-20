//
//  ObservableObject+EXT.swift
//  FetchBook
//
//  Created by Mr. Kavinda Dilshan on 2024-10-20.
//

import SwiftUI

extension ObservableObject {
    // MARK: - binding
    /// Creates a Binding for a given keyPath of a property in an ObservableObject.
    ///
    /// This function returns a Binding that provides a two-way connection to the property defined by the provided keyPath.
    /// It's particularly useful in SwiftUI views where you need to bind view elements to an ObservableObject's properties.
    ///
    /// - Parameter keyPath: A keyPath that references a writable property of the ObservableObject.
    /// - Returns: A Binding to the property referenced by the provided keyPath.
    func binding<T>(_ keyPath: ReferenceWritableKeyPath<Self, T>) -> Binding<T> {
        Binding(
            get: { self[keyPath: keyPath] },
            set: { self[keyPath: keyPath] = $0 }
        )
    }
}
