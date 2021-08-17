//
//  SearchView.swift
//  TestNewsApp
//
//  Created by Rokas Mikelionis on 2021-08-10.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var viewModel: SearchViewModel = SearchViewModel()
    
    init() {
           UIToolbar.appearance().barTintColor = UIColor.white
       }
    
    var body: some View {

        NavigationView {
            VStack {
                SearchBar(search: performSearch)
                HStack {
                    switch viewModel.apiState {
                    case .idle:
                        ForEach(viewModel.searchHistory, id: \.self) { item in
                            Text(item)
                        }
                    case .loading:
                        ProgressView()
                            .frame(maxHeight: .infinity)
                    case .success:
                        ScrollView() {
                            LazyVStack(alignment: .leading) {
                                ForEach(viewModel.articles, id: \.id) { article in
                                    Article(article: article, image: viewModel.newsImages[article.id])
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    case .failed:
                        Text("Couldn't retrieve data")
                    }
                }
                .frame(maxHeight: .infinity)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Image("Logo")
                        
                    }
                }
            }
            
            
        }        
    }
    
    func performSearch(query: String) {
        viewModel.fetchNews(query: query)
    }
}

