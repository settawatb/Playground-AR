//
//  MyProductView.swift
//  Playground_AR
//
//  Created by Settawat Buddhakanchana 26/4/2567 BE.
//

import SwiftUI

struct MyProductView: View {
    @StateObject var viewModel = MyProductViewModel()
    @StateObject var loginData = LoginPageModel()

    var body: some View {
        ScrollView {
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: PurPle))
                    .padding()
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            } else {
                VStack(spacing: 15) {
                    ForEach(viewModel.products) { product in
                        MyProductCard(product: product)
                    }
                }
                .padding(.top, 15)
            }
        }
        .navigationTitle("My Products")
        .onAppear {
            loginData.fetchUserProfile {
                viewModel.fetchSellerProducts(for: loginData.id)
            }
        }
    }
}


struct MyProductCard: View {
    let product: ProductBySeller
    let placeholderImage = "product_4_green_man" // Local placeholder image name

    var body: some View {
        NavigationLink(destination: EditProductView(product: product)) {
            VStack(spacing: 0) {
                HStack(spacing: 15) {
                    // Display the first product image
                    AsyncImage(url: URL(string: product.productImages.first ?? "")) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .frame(width: 100, height: 100)
                                .cornerRadius(6)
                                .shadow(radius: 4, x: 4, y: 4)
                        default:
                            // Use a local placeholder image during loading or failure
                            Image(placeholderImage)
                                .resizable()
                                .frame(width: 100, height: 100)
                                .cornerRadius(6)
                                .shadow(radius: 4, x: 4, y: 4)
                        }
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text(product.title)
                            .font(.custom(customFontBold, size: 18))
                            .lineLimit(2)
                            .foregroundColor(PurPle)
                        
                        Text(product.type.joined(separator: ", "))
                            .font(.custom(customFont, size: 14))
                            .lineLimit(2)
                            .foregroundColor(.black)
                        
                        Text("Amount: \(product.quantity)")
                            .font(.custom(customFont, size: 14))
                            .lineLimit(2)
                            .foregroundColor(.black)
                    }
                }
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    Color.white
                        .cornerRadius(18)
                )
            }
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(style: StrokeStyle(lineWidth: 2))
                    .foregroundColor(.black.opacity(0.2))
            )
        }
    }
}


#Preview {
    MyProductView()
}
