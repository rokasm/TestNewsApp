//
//  TopHeadlinesView.swift
//  TopHeadlinesView
//
//  Created by Rokas Mikelionis on 2021-08-10.
//

import SwiftUI

struct TopHeadlinesView: View {
    @ObservedObject var viewModel: TopHeadlinesViewModel = TopHeadlinesViewModel()

    var body: some View {
        ZStack(alignment: .top) {
            Rectangle().fill(Color("BackgroundColor"))
            VStack {
                Header().zIndex(1)
                switch viewModel.apiState {
                case .loading:
                    ProgressView()
                        .frame(maxHeight: .infinity)
                case .success:
                    ScrollView() {
                        LazyVStack(alignment: .leading) {
                            Text("News").modifier(LabelText()).padding(.leading, 15)
                            ForEach(viewModel.articles, id: \.id) { article in
                                Article(article: article, image: viewModel.newsImages[article.id])
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .offset(y: -5)
                case .failed:
                    Text("Couldn't retrieve data")
                case .idle:
                    EmptyView()
                }
            }
        }
    }
}

struct Header: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.white)
                .frame(height: 45)
                .cornerRadius(15, corners: [.bottomLeft, .bottomRight])
                .shadow(color: .black.opacity(0.06), radius: 5, x: 0, y: 5)
            Image("Logo")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TopHeadlinesView()
    }
}
