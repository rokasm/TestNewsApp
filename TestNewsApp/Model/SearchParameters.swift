//
//  SearchParameters.swift
//  TestNewsApp
//
//  Created by Rokas Mikelionis on 2021-08-18.
//

import Foundation

/// Struct to store search parameters
struct SearchParameters {
    var dateTo = Date()
    var dateFrom = Calendar.current.date(byAdding: DateComponents(month: -6), to: Date()) ?? Date()
    var title: Bool = true
    var description: Bool = true
    var content: Bool = false
    var query: String = ""
    var sortBy: SortBy = .uploadDate
    
    enum SortBy: String {
        case uploadDate = "publishedAt"
        case revelance = "relevance"
    }
    
    enum searchIn: String {
        case title = "Title"
        case description = "Description"
        case content = "Content"
    }
}
