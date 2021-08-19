//
//  FilterSettingsViewModel.swift
//  TestNewsApp
//
//  Created by Rokas Mikelionis on 2021-08-18.
//

import Foundation

class FilterSettingsViewModel: ObservableObject {
    
    @Published private var filterSettings = FilterSettings()
   
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
    
    var dateFrom: Date {
        filterSettings.dateFrom
    }
    
    var dateTo: Date {
        filterSettings.dateTo
    }
    
    var dateFromString: String {
        filterSettings.dateFrom.formatStringForQuery()
    }
    
    var dateToString: String {
        filterSettings.dateTo.formatStringForQuery()
    }
    
    var filterCount: Int {
        var count = 0
        if filterSettings.title || filterSettings.description || filterSettings.content {
                count += 1
        }
        
        if filterSettings.dateTo != Date() {
            count += 1
        }
        
        if filterSettings.dateFrom != Calendar.current.date(byAdding: DateComponents(month: -6), to: Date()) {
            count += 1
        }
        
       return count
    }
    
    func setDateFrom(_ date: Date) {
        filterSettings.dateFrom = date
    }
    
    func setDateTo(_ date: Date) {
        filterSettings.dateTo = date
    }
    
    func setTitle(_ title: Bool) {
        filterSettings.title = title
    }
    
    func setDescription(_ description: Bool) {
        filterSettings.description = description
    }
    
    func setContent(_ content: Bool) {
        filterSettings.content = content
    }
    
    func setQuery(_ query: String) {
        filterSettings.query = query
    }
    
    func setSortBy(_ sortBy: FilterSettings.SortBy) {
        filterSettings.sortBy = sortBy
    }
    
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
    
    func clear() {
        filterSettings = FilterSettings()
    }
       
}
