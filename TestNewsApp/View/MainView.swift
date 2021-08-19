//
//  MainView.swift
//  TestNewsApp
//
//  Created by Rokas Mikelionis on 2021-08-10.
//

import SwiftUI

struct MainView: View {
    @State private var selectedTab = 2
    
    init() {
        let image = UIImage.gradientImageWithBounds(
            bounds: CGRect( x: 0, y: 0, width: UIScreen.main.scale, height: 8),
            colors: [
                UIColor.clear.cgColor,
                UIColor.black.withAlphaComponent(0.06).cgColor
            ]
        )

        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor.white
                
        appearance.backgroundImage = UIImage()
        appearance.shadowImage = image

        UITabBar.appearance().standardAppearance = appearance
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            PlaceholderView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }.tag(0)
            TopHeadlinesView()
                .tabItem {
                    Label("News", systemImage: "circle.grid.2x2")
                }.tag(1)
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }.tag(2)
            PlaceholderView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }.tag(3)
            PlaceholderView()
                .tabItem {
                    Label("More", systemImage: "ellipsis.circle")
                }.tag(4)
        }
        .accentColor(Color("Primary"))
    
    }
}

