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
                VStack(alignment:.center){
                    ProgressView()
                        .controlSize(.large)
                        .progressViewStyle(CircularProgressViewStyle(tint: PurPle))
                        .padding()
                }
                .padding(.top,340)
                .frame(maxWidth: .infinity)
//                .background(.gray)
            } else if viewModel.errorMessage != nil {
                Group{
                    Image("astronaut_2")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                        .padding(.top,35)
                    
                    Text("Product not found")
                        .font(.custom(customFont, size: 25))
                        .fontWeight(.semibold)
                    
                    Text("Try adding your products and come back again 😀")
                        .font(.custom(customFont, size: 18))
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                        .padding(.top, 10)
                        .multilineTextAlignment(.center)
                }
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

    var body: some View {
        NavigationLink(destination: EditProductView(product: product, productImages: product.productImages)) {
            VStack(spacing: 0) {
                HStack(spacing: 20) {
                    AsyncImage(url: URL(string: product.productImages.first ?? "")) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .cornerRadius(15)
                                .shadow(radius: 3, x: 2, y: 2)
                        case .failure:
                            Image("image_placeholder")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .cornerRadius(15)
                                .shadow(radius: 3, x: 2, y: 2)
                        case .empty:
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: PurPle))
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .cornerRadius(15)
                                .shadow(radius: 3, x: 2, y: 2)
                        @unknown default:
                            Image("image_placeholder")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .cornerRadius(15)
                                .shadow(radius: 3, x: 2, y: 2)
                        }
                    }

                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(product.title)
                            .font(.custom(customFontBold, size: 20))
                            .lineLimit(1)
                            .foregroundColor(.black)
                        
                        HStack{
                            Text(product.type[0])
                                .font(.custom(customFont, size: 15))
                                .lineLimit(1)
                                .foregroundColor(.black)
                                .padding(.vertical,1)
                                .padding(.horizontal,10)
                                .overlay(
                                    Capsule()
                                        .stroke(PurPle, lineWidth: 2)
                                    
                                )
                            Spacer()
                 
                        }
                        HStack{
                            Text("฿ "+(Int(product.price)).formattedWithSeparator)
                                .font(.custom(customFont, size: 15))
                                .foregroundColor(.gray)
                                .lineLimit(2)
                            Spacer()
                            Text("Quantity : \(product.quantity)")
                                .font(.custom(customFont, size: 15))
                                .foregroundColor(.gray)
                                .lineLimit(2)
                        }
                        
                    }
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    Color.white
                        .cornerRadius(10)
                )
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
            }
        }
    }
}


#Preview {
    MyProductView()
}
