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
                    .aspectRatio(contentMode: .fit)
            case .failure, .empty:
                Image("image_placeholder")
                    .resizable()
                    .frame(width: 100,height: 100)
                    .aspectRatio(contentMode: .fit)
            @unknown default:
                Image("image_placeholder")
                    .resizable()
                    .frame(width: 100,height: 100)
                    .aspectRatio(contentMode: .fit)
            }
        }
        .cornerRadius(25)
    }
}

struct ProductImageDetailView: View {
    var urlStrings: [String]

    var body: some View {
        TabView {
            ForEach(urlStrings.indices, id: \.self) { index in
                AsyncImage(url: URL(string: urlStrings[index])) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(25)
                    case .failure, .empty:
                        Image("image_placeholder")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(25)
                    @unknown default:
                        Image("image_placeholder")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(25)
                    }
                }
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic)) // Add page control indicator
        .frame(maxHeight: .infinity) // Set max height
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

