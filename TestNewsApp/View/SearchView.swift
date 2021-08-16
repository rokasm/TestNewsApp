//
//  SearchView.swift
//  TestNewsApp
//
//  Created by Rokas Mikelionis on 2021-08-10.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var viewModel: SearchViewModel = SearchViewModel()
    @State var searchString: String = ""
    
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .fill(Color.white)
                    .frame(maxHeight: 55)
                    .cornerRadius(15, corners: [.bottomLeft, .bottomRight])
                    .shadow(color: .black.opacity(0.06), radius: 5, x: 0, y: 5)
                Image("Logo")
            }
            HStack {
                Button(action: { self.performSearch() }) {
                    Image(systemName: "magnifyingglass")
                }
                TextField("Start typing",
                          text: $searchString,
                          onCommit: { self.performSearch() })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            switch viewModel.apiState {
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
            case .idle:
                EmptyView()
            }
        }
    }
    
    func performSearch() {
        viewModel.fetchNews(query: searchString)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
