//
//  SearchInView.swift
//  TestNewsApp
//
//  Created by Rokas Mikelionis on 2021-08-18.
//

import SwiftUI

struct SearchInView: View {
    @EnvironmentObject var filterSettings: FilterSettingsViewModel
    @State private var title: Bool = true
    @State private var description: Bool = true
    @State private var content: Bool  = false
  
    var body: some View {
        ZStack(alignment: .topLeading) {
            Rectangle().fill(Color.white)
            VStack(alignment: .leading) {
                Toggle("Title", isOn: $title).modifier(LabelTextSm()).imageScale(.small).toggleStyle(SwitchToggleStyle(tint: Color("Primary"))).padding(.trailing, 15)
                    .onChange(of: title) { value in
                        filterSettings.setTitle(value)
                    }
                Divider().background(Color("BackgroundColor")).padding(.horizontal, 15)
                Toggle("Description", isOn: $description).modifier(LabelTextSm()).imageScale(.small).toggleStyle(SwitchToggleStyle(tint: Color("Primary"))).padding(.trailing, 15)
                    .onChange(of: description) { value in
                        filterSettings.setDescription(value)
                    }
                Divider().background(Color("BackgroundColor")).padding(.horizontal, 15)
                Toggle("Content", isOn: $content).modifier(LabelTextSm()).toggleStyle(SwitchToggleStyle(tint: Color("Primary"))).padding(.trailing, 15)
                    .onChange(of: content) { value in
                        filterSettings.setContent(value)
                    }
                Divider().background(Color("BackgroundColor")).padding(.horizontal, 15)
            }.padding(.leading, 15)
        }
        .modifier(TopBar())
        .toolbar {
            Button {
                clear()
            } label: {
                HStack {
                    Text("Clear").offset(x: 5)
                    Image(systemName: "trash")
                }
            }
        }
        .onAppear {
            title = filterSettings.title
            description = filterSettings.description
            content = filterSettings.content
        }
    }
    func clear() {
        filterSettings.clear()
        title = filterSettings.title
        description = filterSettings.description
        content = filterSettings.content
    }
}

