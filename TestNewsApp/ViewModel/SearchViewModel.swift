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
    
    func fetchNews(query: String, sortBy: String = "publishedAt", searchIn: String = "title,description") {
        apiState = .loading
        let url = "https://gnews.io/api/v4/search?q=\(query)&token=\(self.token)&sortBy=\(sortBy)&in=\(searchIn)&lang=en"
        let apiURL = URL(string: url)!
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
                print(someValue)
                self?.searchResults = someValue
                self?.apiState = .success
                self?.searchHistory.append(query)
                UserDefaults.standard.set(self?.searchHistory, forKey: "searchHistory")
                self?.fetchImages()
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
}
