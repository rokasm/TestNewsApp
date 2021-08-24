//
//  SearchView.swift
//  TestNewsApp
//
//  Created by Rokas Mikelionis on 2021-08-10.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var viewModel: SearchViewModel = SearchViewModel()
    @StateObject var filterSettings = FilterSettingsViewModel()
    @State var passedBottomSheetShown: Bool = false
    @State var sortBy: SearchParameters.SortBy = .uploadDate
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                ZStack(alignment: .topLeading) {
                    Rectangle().fill(Color("BackgroundColor"))
                    VStack {
                        SearchBar(search: performSearch, bottomSheetShown: $passedBottomSheetShown).environmentObject(filterSettings).zIndex(1)
                        switch viewModel.apiState {
                        case .idle:
                            ScrollView() {
                                VStack(alignment: .leading) {
                                    Text("Recent Searches").modifier(LabelText()).frame(maxWidth: .infinity, alignment: .leading)
                                    ForEach(viewModel.searchHistory, id: \.self) { item in
                                        Text(item).font(.custom("Open Sans", size: 12))
                                            .padding(.vertical, 5)
                                            .foregroundColor(Color("TextGray"))
                                            .onTapGesture {
                                                viewModel.getQuery(query: item)
                                            }
                                        Rectangle().foregroundColor(.white).frame(height: 1)
                                    }
                                }
                            }
                            .offset(y: -12)
                            .padding(.horizontal, 15)
                            .padding(.top, 5)
                        case .loading:
                            ProgressView()
                                .frame(maxHeight: .infinity)
                        case .success:
                            ScrollView() {
                                LazyVStack(alignment: .leading) {
                                    Text("\(String(viewModel.totalArticles)) news").modifier(LabelText()).padding(.leading, 15)
                                    ForEach(viewModel.articles, id: \.id) { article in
                                        Article(article: article, image: viewModel.newsImages[article.id])
                                    }
                                }
                            }
                            .offset(y: -12)
                            .padding(.top, 5)
                            .frame(maxWidth: .infinity, alignment: .leading).offset()
                        case .failed:
                            Text("Couldn't retrieve data")
                                .frame(maxHeight: .infinity)
                        }
                    }
                    .frame(maxHeight: .infinity)
                    .modifier(TopBar())
                }
            }.padding(.top, 5)
            .navigationViewStyle(StackNavigationViewStyle())
            BottomSheetView(
                isOpen: $passedBottomSheetShown,
                maxHeight: geometry.size.height * 0.5
            ) {
                    Color.white
                    VStack(alignment: .leading) {
                        Text("Filter").modifier(LabelText()).padding(.top, 10)
                        Divider().background(Color("BackgroundColor"))
                        
                        Picker(selection: $sortBy, label: Text("Avocado:")) {
                            Text("Upload Date").tag(SearchParameters.SortBy.uploadDate)
                            Text("Relevance").tag(SearchParameters.SortBy.revelance)
                        }
                        .onChange(of: sortBy) { value in
                            filterSettings.setSortBy(value)
                        }
                        .padding(.bottom, 50)
                    }.padding(.horizontal, 15)
            }
        }.edgesIgnoringSafeArea(.all)
    }
    
    func performSearch() {
        viewModel.fetchNews(searchParameters: filterSettings)
    }
}
