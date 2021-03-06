//
//  FilterSettingsViewModel.swift
//  TestNewsApp
//
//  Created by Rokas Mikelionis on 2021-08-18.
//

import Foundation

class FilterSettingsViewModel: ObservableObject {
    
    @Published private var filterSettings = SearchParameters()
   
    var title: Bool {
        filterSettings.title
    }
    
    var description: Bool {
        filterSettings.description
    }
    
    var content: Bool {
        filterSettings.content
    }
    
    var searchIn: String {
        var labels: [String] = []
        if filterSettings.title {
            labels.append("Title")
        }
        if filterSettings.description {
            labels.append("Description")
        }
        
        if filterSettings.content {
            labels.append("Content")
        }
        
        return labels.joined(separator: ",")
    }
  
    var query: String {
        filterSettings.query
    }
    
    var sortBy: String {
        filterSettings.sortBy.rawValue
    }
    
    var dateFrom: String {
        filterSettings.dateFrom
    }
    
    var dateTo: String {
        filterSettings.dateTo
    }
     
    var filterCount: Int {
        var count = 0
        if filterSettings.title || filterSettings.description || filterSettings.content {
                count += 1
        }
        
        if filterSettings.dateTo != "" {
            count += 1
        }
        
        if filterSettings.dateFrom != "" {
            count += 1
        }
        
       return count
    }

    /// Sets  a date from string to apply as a filter
    /// - Parameter date: String value as date to search articles from
    func setDateFrom(_ date: String) {
        filterSettings.dateFrom = date
    }
    
    /// Sets a date from string to apply as a filter
    /// - Parameter date: String value as date to search articles to
    func setDateTo(_ date: String) {
        filterSettings.dateTo = date
    }
        
    /// Sets if search will be operated in the titles of articles
    /// - Parameter title: Value to be set
    func setTitle(_ title: Bool) {
        filterSettings.title = title
    }
    
    /// Sets if search will be operated in the descriptions of articles
    /// - Parameter title: Value to be set
    func setDescription(_ description: Bool) {
        filterSettings.description = description
    }
    
    /// Sets if search will be operated in the contents of articles
    /// - Parameter title: Value to be set
    func setContent(_ content: Bool) {
        filterSettings.content = content
    }
    
    /// Sets search query to be used in search
    /// - Parameter title: Value to be set
    func setQuery(_ query: String) {
        filterSettings.query = query
    }
    
    /// Sets sorting of articles type
    /// - Parameter title: Value to be set. "uploadDate" or "Relevance"
    func setSortBy(_ sortBy: SearchParameters.SortBy) {
        filterSettings.sortBy = sortBy
    }
    
    // Sets sections to be searched in from a string value
    /// - Parameter searchInString: String value of sections
    func setSearchIn(_ searchInString: String) {
        filterSettings.title = searchInString.contains(SearchParameters.searchIn.title.rawValue)
        filterSettings.description = searchInString.contains(SearchParameters.searchIn.description.rawValue)
        filterSettings.content = searchInString.contains(SearchParameters.searchIn.content.rawValue)
    }
    
    
    /// Creates a label to display in which article sections search will operate
    /// - Returns: Search locations label
    func createSearchInLabel() -> String {
        var labels: [String] = []
        if filterSettings.title {
            labels.append("Title")
        }
        if filterSettings.description {
            labels.append("Description")
        }
        
        if filterSettings.content {
            labels.append("Content")
        }
        
        switch labels.count {
            case 3:
                return "All"
        case 2:
            return labels.joined(separator: ", ")
        case 1:
            return String(labels[0])
        default:
            return ""
        }
    }
    
    /// Clears search filters
    func clear() {
        filterSettings = SearchParameters()
    }
       
}
