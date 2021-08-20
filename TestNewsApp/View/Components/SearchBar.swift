//
//  SearchBar.swift
//  TestNewsApp
//
//  Created by Rokas Mikelionis on 2021-08-17.
//
import SwiftUI

struct SearchBar: View {
    @State var searchString: String = ""
    var search: () -> Void
    @EnvironmentObject var filterSettings: FilterSettingsViewModel
    @Binding var bottomSheetShown: Bool 

    var body: some View {
        ZStack(alignment: .top) {
            Rectangle()
                .fill(Color.white)
                .frame(height: 70)
                .cornerRadius(30, corners: [.bottomLeft, .bottomRight])
                .shadow(color: .black.opacity(0.06), radius: 5, x: 0, y: 5)
            HStack {
                HStack {
                    Button(action: {
                            filterSettings.setQuery(searchString)
                            self.search() }) {
                        Image(systemName: "magnifyingglass")
                    }
                    TextField("Start typing", text: $searchString, onEditingChanged: { began in
                        if !began {
                            filterSettings.setQuery(searchString)
                            self.search()
                        }
                    })
                }
                .modifier(SearchBarStyle())
                .padding(.vertical, 10)
                ZStack {
                    Circle().foregroundColor(Color("BackgroundColor"))
                    NavigationLink(destination: FilterView().environmentObject(filterSettings), label: { Image("filter").resizable().padding(15) })
                    ZStack {
                        Circle().foregroundColor(Color.red)
                        Text("\(filterSettings.filterCount)").font(.custom("Open Sans", size: 11)).foregroundColor(.white)
                    }
                    .frame(width: 15, height: 15).offset(x: 15, y: -15)
                }
                .frame(width: 46, height: 46)
                ZStack {
                    if bottomSheetShown {
                        Circle().foregroundColor(Color("Primary"))
                        Image("sort_white").resizable().padding(15)
                    } else {
                        Circle().foregroundColor(Color("BackgroundColor"))
                        Image("sort").resizable().padding(15)
                    }
                }
                .frame(width: 46, height: 46)
                .onTapGesture {
                    withAnimation {
                        bottomSheetShown.toggle()
                    }
                }
            }.padding(.horizontal, 10)
        }
        .background(Color("BackgroundColor"))
    }
}

struct SearchBarStyle: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .padding(15)
            .background(Color("BackgroundColor"))
            .cornerRadius(50)
            .foregroundColor(Color("TextLightGray"))
            .font(.custom("Open Sans", size: 14))
    }
}
