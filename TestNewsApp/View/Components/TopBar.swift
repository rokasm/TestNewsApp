//
//  TopBar.swift
//  TestNewsApp
//
//  Created by Rokas Mikelionis on 2021-08-17.
//

import SwiftUI

struct TopBar: ViewModifier {
    
    let coloredNavAppearance = UINavigationBarAppearance()
    
    
    init() {
        coloredNavAppearance.configureWithOpaqueBackground()
        coloredNavAppearance.backgroundColor = .white
        coloredNavAppearance.shadowColor = .clear
        UINavigationBar.appearance().standardAppearance = coloredNavAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredNavAppearance
    }
    
    func body(content: Content) -> some View {
        content
            .navigationBarTitle("", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    ZStack {
                        Image("Logo")
                    }
                }
            }
    }
}
