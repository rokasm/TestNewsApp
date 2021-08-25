//
//  TopHeadlinesModel.swift
//  TestNewsApp
//
//  Created by Rokas Mikelionis on 2021-08-10.
//

import Foundation
import Combine
import UIKit

class TopHeadlinesViewModel: ObservableObject {
    @Published private(set) var topHeadlines: Articles?
    private var fetchTopNewsCancellable: AnyCancellable?
    private let apiURL: URL
    private let token: String = "5fcd85430666d68dee6b96229b7f0213"

    init() {
        let url = "https://gnews.io/api/v4/top-headlines?token=\(self.token)&lang=en"
        apiURL = URL(string: url)!
        if let storage = UserDefaults.standard.data(forKey: "news") {
            if let savedData =  try? JSONDecoder().decode(Articles.self, from: storage) {
                topHeadlines = savedData
                apiState = .success
                fetchImages()
            } else {
                apiState = .loading
                fetchNews()
            }
        } else {
            apiState = .loading
            fetchNews()
        }
    }
    
    /// Fetches top news from the api and stores it Articles struct
    func fetchNews() {
        let remoteDataPublisher = URLSession.shared.dataTaskPublisher(for: apiURL)
            .map { $0.data }
            .decode(type: Articles.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)

        fetchTopNewsCancellable = remoteDataPublisher
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure:
                    self?.apiState = .failed
                }
            }, receiveValue: { [weak self] someValue in
                self?.topHeadlines = someValue
                self?.apiState = .success
                UserDefaults.standard.set(someValue.json, forKey: "news")
                self?.fetchImages()
            })
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
    
    var image: UIImage = UIImage() {
        willSet {
            objectWillChange.send()
        }
    }
    
    var articles: [Articles.Article] {
        topHeadlines?.articles ?? []
    }
       
    /// Fetches images from url received from api
    private func fetchImages() {
        topHeadlines?.articles.forEach{ [weak self] article in
            DispatchQueue.global(qos: .default).async {
                if let imageData = try? Data(contentsOf: URL(string: article.image)!) {
                    DispatchQueue.main.async {
                        self?.newsImages.updateValue(UIImage(data: imageData) ?? UIImage(), forKey: article.id)
                    }
                }
            }
          
        }
    }
}
