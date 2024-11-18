//
//  ContentNotAvailableModel.swift
//  FetchBook
//
//  Created by Kavinda Dilshan on 2024-11-18.
//

import Foundation

struct ContentNotAvailableModel {
    // MARK:  - PROPERTIES
    let systemImageName: String?
    let title: String
    let description: String?
    
    // MARK: - INITIALIZER
    init(systemImageName : String? = nil, title: String, description: String? = nil) {
        self.systemImageName    = systemImageName
        self.title              = title
        self.description        = description
    }
}
