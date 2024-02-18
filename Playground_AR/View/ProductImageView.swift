//
//  ProductImageView.swift
//  Playground_AR
//
//  Created by Kisses MJ on 18/2/2567 BE.
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
                    .aspectRatio(contentMode: .fit) // You can experiment with other content modes like .fill, .fit, etc.
            case .failure, .empty:
                Image("image_placeholder")
                    .resizable()
                    .aspectRatio(contentMode: .fit) // Adjust content mode as needed
            @unknown default:
                Image("image_placeholder")
                    .resizable()
                    .aspectRatio(contentMode: .fit) // Adjust content mode as needed
            }
        }
        .cornerRadius(25)
    }
}
