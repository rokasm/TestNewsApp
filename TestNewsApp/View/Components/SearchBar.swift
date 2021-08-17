//
//  SearchBar.swift
//  TestNewsApp
//
//  Created by Rokas Mikelionis on 2021-08-17.
//

import SwiftUI

struct SearchBar: View {
    @State var searchString: String = ""
    var search: (String) -> Void

    var body: some View {
        ZStack(alignment: .top) {
            Rectangle()
                .fill(Color.white)
                .frame(height: 55)
                .cornerRadius(15, corners: [.bottomLeft, .bottomRight])
                .shadow(color: .black.opacity(0.06), radius: 5, x: 0, y: 5)
            HStack {
                Button(action: { self.search(searchString) }) {
                    Image(systemName: "magnifyingglass")
                }
                TextField("Start typing",
                          text: $searchString,
                          onCommit: { self.search(searchString) })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                NavigationLink(destination: Text("filter"), label: { Image("filter") })
                NavigationLink(destination: Text("filter"), label: { Image("sort") })
            }
        }
    }
}

