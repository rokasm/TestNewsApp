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
    
    func fetchNews(query: String, sortBy: String = "publishedAt", searchIn: String = "title,description", from: String = "", to: String = "") {
        if query == "" {
            apiState = .idle
            return
        }
        apiState = .loading
        var components = URLComponents()
        components.scheme = "https"
        components.host = "gnews.io"
        components.path = "/api/v4/search"
        components.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "sortBy", value: sortBy),
            URLQueryItem(name: "in", value: searchIn),
            URLQueryItem(name: "from", value: from),
            URLQueryItem(name: "to", value: to),
            URLQueryItem(name: "token", value: self.token),
            URLQueryItem(name: "lang", value: "en"),
        ]
        let apiURL = components.url!
        print(apiURL)
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
                self?.searchHistory.append(query)
                self?.truncateSearchHistory()
                self?.fetchImages()
                UserDefaults.standard.set(self?.searchHistory, forKey: "searchHistory")
                UserDefaults.standard.set(["query": query, "sortBy": sortBy, "searchIn": searchIn, "from": from, "to": to], forKey: query)

            })
    }
    
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
    
    func getQuery(query: String) {
        if let query = UserDefaults.standard.object(forKey: query) as?  [String : String] {
            fetchNews(query: query["query"]! , sortBy: query["sortBy"]! , searchIn: query["searchIn"]! , from: query["from"]! , to: query["to"]! )
        }
    }
    
    func truncateSearchHistory() {
        let truncated = searchHistory.unique.prefix(10)
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
