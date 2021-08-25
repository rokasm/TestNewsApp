//
//  SearchViewModel.swift
//  TestNewsApp
//
//  Created by Rokas Mikelionis on 2021-08-16.
//

import Foundation
import Combine
import UIKit

class SearchViewModel: ObservableObject {
    
    @Published private(set) var searchResults: Articles?
    
    private var fetchSearchResultCancellable: AnyCancellable?
    private let token: String = "5fcd85430666d68dee6b96229b7f0213"
    var searchHistory: [String] = []
    
    init() {
        apiState = .idle
        searchHistory = UserDefaults.standard.stringArray(forKey: "searchHistory") ?? []
    }
    
    /// Fetches news from the api by the search parameters and stores it in Articles model.
    /// - Parameters:
    ///   - query: Search query
    ///   - sortBy: Specifies sorting of fetched news, default is by date,  other option is by revelance
    ///   - searchIn: Specifies the sections of sections of news article to search for query
    ///   - from: Specifies date to search article from
    ///   - to: Specifies date to search article to
    func fetchNews(searchParameters: FilterSettingsViewModel) {
        if searchParameters.query == "" {
            apiState = .idle
            return
        }
        apiState = .loading
        var components = URLComponents()
        components.scheme = "https"
        components.host = "gnews.io"
        components.path = "/api/v4/search"
        components.queryItems = [
            URLQueryItem(name: "q", value: searchParameters.query),
            URLQueryItem(name: "sortBy", value: searchParameters.sortBy),
            URLQueryItem(name: "in", value: searchParameters.searchIn),
            URLQueryItem(name: "from", value: searchParameters.dateFrom),
            URLQueryItem(name: "to", value: searchParameters.dateTo),
            URLQueryItem(name: "token", value: self.token),
            URLQueryItem(name: "lang", value: "en"),
        ]
        let apiURL = components.url!
        let remoteDataPublisher = URLSession.shared.dataTaskPublisher(for: apiURL)
            .map { $0.data }
            .decode(type: Articles.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
        
        fetchSearchResultCancellable = remoteDataPublisher
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure:
                    self?.apiState = .failed
                }
            }, receiveValue: { [weak self] someValue in
                self?.searchResults = someValue
                self?.apiState = .success
                self?.searchHistory.append(searchParameters.query)
                self?.truncateSearchHistory()
                self?.fetchImages()
                UserDefaults.standard.set(self?.searchHistory, forKey: "searchHistory")
                UserDefaults.standard.set(["query": searchParameters.query, "sortBy": searchParameters.sortBy, "searchIn": searchParameters.searchIn, "from": searchParameters.dateFrom, "to": searchParameters.dateTo], forKey: searchParameters.query)

            })
    }
    
    /// Fetches images from url received from api
    private func fetchImages() {
        searchResults?.articles.forEach{ [weak self] article in
            DispatchQueue.global(qos: .default).async {
                if let imageData = try? Data(contentsOf: URL(string: article.image)!) {
                    DispatchQueue.main.async {
                        self?.newsImages.updateValue(UIImage(data: imageData)!, forKey: article.id)
                    }
                }
            }
            
        }
    }

    var articles: [Articles.Article] {
        searchResults?.articles ?? []
    }
    
    var totalArticles: Int {
        searchResults?.totalArticles ?? 0
    }
    
    var apiState: APIState {
        willSet {
            objectWillChange.send()
        }
    }
    
    var newsImages: [UUID : UIImage] = [:] {
        willSet {
            objectWillChange.send()
        }
    }
        
    /// Generates search query from storage and returns search results
    /// - Parameter query: Query value wich is used as a name for search storage
    func getQuery(query: String) {
        if let query = UserDefaults.standard.object(forKey: query) as? [String : String] {
            let storedParameters = FilterSettingsViewModel()
            storedParameters.setQuery(query["query"] ?? "")
            if let sortBy = SearchParameters.SortBy.init(rawValue: query["sortBy"]!) {
                storedParameters.setSortBy(sortBy)
            }
            storedParameters.setSearchIn(query["searchIn"] ?? "")
            storedParameters.setDateFrom(query["from"] ?? "")
            storedParameters.setDateTo(query["to"] ?? "")
            fetchNews(searchParameters: storedParameters)
        }
    }
    
    /// Generates last 10 search queries
    func truncateSearchHistory() {
        let truncated = searchHistory.reversed().unique.prefix(10)
        searchHistory = Array(truncated)
    }

    struct Params: Codable {
       var query: String = ""
       var sortBy: String = ""
       var searchIn: String = ""
       var from: String = ""
       var to: String = ""
    }
}
