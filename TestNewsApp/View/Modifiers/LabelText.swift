//
//  LabelText.swift
//  TestNewsApp
//
//  Created by Rokas Mikelionis on 2021-08-17.
//

import SwiftUI

struct LabelText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Open Sans", size: 15))
            .foregroundColor(.black)
            .padding(.top, 10)
    }
}

struct LabelTextSm: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Open Sans", size: 12))
            .foregroundColor(.black)
            .padding(.top, 10)
    }
}

struct LabelTextSmGray: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Open Sans", size: 12))
            .foregroundColor(Color("TextLightGray"))
            .padding(.top, 10)
    }
}


struct LabelTextXs: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Open Sans", size: 11))
            .foregroundColor(.black)
            .padding(.top, 10)
    }
}
