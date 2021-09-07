//
//  ArticleView.swift
//  TestNewsApp
//
//  Created by Rokas Mikelionis on 2021-08-16.
//

import SwiftUI

struct Article: View {
    var article: Articles.Article
    var image: UIImage?
    @State private var showingSheet = false

    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .top, spacing: 0) {
                ZStack {
                    Rectangle().foregroundColor(Color("BackgroundColor"))
                    OptionalImage(uiImage: image)
                        .scaledToFill()
                }
                .frame(width:imageWidth, height: imageHeight, alignment: .center)
                .clipped()
                VStack(alignment: .leading) {
                    Text(article.title)
                        .font(.custom("Open Sans", size: 13))
                        .padding(.vertical, 2)
                        .foregroundColor(.black)
                    Text(article.description)
                        .foregroundColor(Color.gray)
                        .font(.system(size: 11))
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 5)
                .frame(width: articleWidth(geometry.size), height: imageHeight)
                .background(Color.white)
            }
            .shadow(color: .black.opacity(0.06), radius: 2, x: 0, y: 0)
        }
        .padding(.horizontal, 15)
        .frame(height: 113)
        .onTapGesture {
            showingSheet.toggle()
        }
        .sheet(isPresented: $showingSheet) {
            Webview(url: URL(string: article.url)!)
        }
    }
        
    func articleWidth(_ size: CGSize) -> CGFloat {
        abs(size.width - 124)
    }
    
    var imageWidth: CGFloat = 124
    var imageHeight: CGFloat = 108
    
}
