//
//  TopHeadlines.swift
//  TestNewsApp
//
//  Created by Rokas Mikelionis on 2021-08-10.
//

import Foundation

struct Articles: Codable {
    var totalArticles: Int
    var articles: [Article]
    
    struct Article: Codable {
        var title: String
        var description: String
        var url: String
        var image: String
        var publishedAt: String
        var source: Source
        
        let id = UUID()
        
        private enum CodingKeys: String, CodingKey {
            case title, description, url, image, publishedAt, source
        }
    }
    
    struct Source: Codable {
        var name: String
        var url: String
    }
    
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
}
