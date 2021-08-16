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
                Header()
                switch viewModel.apiState {
                case .loading:
                    ProgressView()
                        .frame(maxHeight: .infinity)
                case .success:
                    ScrollView() {
                        LazyVStack(alignment: .leading) {
                            Text("News")
                                .font(Font.custom("Open Sans", size: 16))
                                .foregroundColor(.black)
                                .padding(.top, 15)
                                .padding(.leading, 15)
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
    }
}

struct Header: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.white)
                .frame(height: 55)
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
