//
//  ProductImageView.swift
//  Playground_AR
//
//  Created by Settawat Buddhakanchana on 18/2/2567 BE.
//


import SwiftUI

struct ProductImageView: View {
    var urlString: String

    var body: some View {
        AsyncImage(url: URL(string: urlString)) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .frame(width: 100,height: 100)
                    .aspectRatio(contentMode: .fill)
            case .failure, .empty:
                Image("image_placeholder")
                    .resizable()
                    .frame(width: 100,height: 100)
                    .aspectRatio(contentMode: .fill)
            @unknown default:
                Image("image_placeholder")
                    .resizable()
                    .frame(width: 100,height: 100)
                    .aspectRatio(contentMode: .fill)
            }
        }
        .cornerRadius(15)
    }
}

struct ProductImageDetailView: View {
    var urlStrings: [String]

    var body: some View {
        TabView {
            ForEach(urlStrings.indices, id: \.self) { index in
                // Use ZoomableScrollView to wrap AsyncImage
                ZoomableScrollView(content: AsyncImage(url: URL(string: urlStrings[index])) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .cornerRadius(15)
                    case .failure:
                        Image("image_placeholder")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .cornerRadius(15)
                    default:
                        ProgressView()
                    }
                })
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .frame(maxHeight: .infinity)
    }
}






struct ProductImageCheckoutView: View {
    var urlString: String

    var body: some View {
        AsyncImage(url: URL(string: urlString)) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .frame(width: 100,height: 100)
                    .aspectRatio(contentMode: .fit)
                    .shadow(radius: 4, x: 4, y: 4)
            case .failure, .empty:
                Image("image_placeholder")
                    .resizable()
                    .frame(width: 100,height: 100)
                    .aspectRatio(contentMode: .fit)
                    .shadow(radius: 4, x: 4, y: 4)
            @unknown default:
                Image("image_placeholder")
                    .resizable()
                    .frame(width: 100,height: 100)
                    .aspectRatio(contentMode: .fit)
                    .shadow(radius: 4, x: 4, y: 4)
            }
        }
        .cornerRadius(6)
    }
}

