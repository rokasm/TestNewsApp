//
//  OptionalImage.swift
//  TestNewsApp
//
//  Created by Rokas Mikelionis on 2021-08-11.
//

import SwiftUI

struct OptionalImage: View {
    var uiImage: UIImage?
    
    var body: some View {
        Group {
            if uiImage != nil {
                Image(uiImage: uiImage!)
                    .resizable()
            }
        }
    }
}
