//
//  ProductDetailView.swift
//  Playground_AR
//
//  Created by Settawat Buddhakanchana on 25/12/2566 BE.
//

import SwiftUI

struct ProductDetailView: View {
    var product: Product
    var animation: Namespace.ID
    @EnvironmentObject var sharedData: SharedDataModel
    @EnvironmentObject var homeData: HomeViewModel
    @State private var isARModeActive: Bool = false
    @State private var isShowingARModeView: Bool = false
    
    var body: some View {
        VStack (spacing: 0) {
            // Title Bar and Product Image
            VStack {
                // Title Bar
                HStack {
                    Button {
                        // Closing View
                        withAnimation(.easeInOut) {
                            sharedData.showDetailProduct = false
                        }
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.title2)
                            .foregroundColor(Color.black.opacity(0.7))
                    }
                    
                    Spacer()
                        .onTapGesture {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }
                    
                    Button {
                        addToFav()
                    } label: {
                        Image("Favorite")
                            .renderingMode(.template)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                            .foregroundColor(isFavorited() ? .red : Color.black.opacity(0.7))
                    }
                }
                .padding()
                
                // Product Image
                ProductImageDetailView(urlStrings: product.productImages)
                    .matchedGeometryEffect(id: "\(product.id)\(sharedData.fromSearchPage ? "SEARCH" : "IMAGE")", in: animation)
                    .padding(.horizontal, 5)
                    .offset(y: -12)
                    .frame(maxHeight: .infinity)
            }
            .padding(.top)
            .zIndex(1)
            
            // Product Details
            ScrollView(.vertical, showsIndicators: false) {
                // Product Data
                VStack(alignment: .leading, spacing: 5) {
                    Text(product.title)
                        .font(.custom(customFontBold, size: 35))
                    let formattedDate = DateFormatter.dayMonthYear.string(from: product.updateAt)
                    Text(product.type[0].rawValue)
                        .font(.custom(customFont, size: 20))
                        .lineLimit(1)
                        .padding(.vertical,1)
                        .padding(.horizontal,10)
                        .overlay(
                            Capsule()
                                .stroke(PurPle, lineWidth: 2)
                        )
                        .padding(.bottom)
                    HStack{
                        Text("Seller : ")
                            .font(.custom(customFontBold, size: 15))
                            .foregroundStyle(Color.black)
                        +
                        Text(product.productSeller.sellerName)
                            .font(.custom(customFont, size: 15))
                            .foregroundStyle(Color.black)
                        +
                        Text("   Stock : ")
                            .font(.custom(customFontBold, size: 15))
                            .foregroundStyle(Color.black)
                        +
                        Text("\(product.quantity ?? 1)")
                            .font(.custom(customFont, size: 15))
                            .foregroundStyle(Color.gray)
                        
                        
                        Text("   Update Date :  ")
                            .font(.custom(customFontBold, size: 15))
                            .foregroundStyle(Color.black)
                        +
                        Text(formattedDate)
                            .font(.custom(customFont, size: 15))
                            .foregroundStyle(Color.gray)
                    }
                    Text("Ships from   :  ")
                        .font(.custom(customFontBold, size: 15))
                        .foregroundStyle(Color.black)
                    +
                    Text(product.productSeller.sellerAddress)
                        .font(.custom(customFont, size: 15))
                        .foregroundStyle(Color.gray)
                    
//                    Divider().background(Color.black.opacity(0.4)).padding(.vertical)
                    
                    Text("Detail")
                        .font(.custom(customFontBold, size: 15))
                        .foregroundStyle(Color.black)
                    Text(product.description)
                        .font(.custom(customFont, size: 16))
                        .foregroundStyle(Color.gray)
                }
                .padding([.horizontal,.top])
            }
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .zIndex(1)
            .background(Color.white)
            .clipShape(CustomCorners(corners: [.topLeft, .topRight], radius: 25))
            
            VStack(alignment: .leading, spacing:0) {
                VStack(alignment: .leading){
                    Text("Price")
                        .font(.custom(customFont, size: 20))
                    
                    Text((Int(product.price) ?? 0).formattedWithSeparator + " THB")
                        .font(.custom(customFontBold, size: 30))
                        .foregroundColor(.black)
                }
                .padding(.bottom, 10)
                
                HStack {
                    // AR button
                    Button {
                        // activateARMode()
                        isShowingARModeView = true
                    } label: {
                        Image("AR")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(.vertical, 6)
                            .frame(maxWidth: 63, maxHeight: 63)
                            .colorMultiply(Color.white)
                            .background(
                                Color(PurPle)
                                    .cornerRadius(10)
                                    .shadow(color: Color.black.opacity(0.01), radius: 5, x: 5, y: 5)
                            )
                    }
                    .sheet(isPresented: $isShowingARModeView) {
                        ARModeView(productTitle: product.title, model3DURL: product.productModel).navigationTitle("AR Mode Title")
                    }
                    
                    // Add to cart button
                    Button {
                        addToCart()
                    } label: {
                        Text("\(isAddedToCart() ? "Added" : "Add" ) to cart")
                            .font(.custom(customFont, size: 20).bold())
                            .foregroundColor(Color.white)
                            .padding(.vertical, 20)
                            .frame(maxWidth: .infinity)
                            .background (
                                isAddedToCart() ? Color(PurPle).opacity(0.5) : Color(.black)
                            )
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x:5, y:5)
                    }
                }
            }
            .padding(30)
            .zIndex(99)
            .background(.white)
            .clipShape(CustomCorners(corners: [.topLeft, .topRight], radius: 25))
            .shadow(radius: 4)
        }
        .padding(.top,8)
        .ignoresSafeArea()
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .animation(.easeInOut, value: sharedData.favoritedProducts)
        .animation(.easeInOut, value: sharedData.cartProducts)
        .background(LightGray.ignoresSafeArea())
    }
    
    func isFavorited() -> Bool {
        sharedData.favoritedProducts.contains { product in
            self.product.id == product.id
        }
    }
    
    func isAddedToCart() -> Bool {
        sharedData.cartProducts.contains { product in
            self.product.id == product.id
        }
    }
    
    func addToFav() {
        if let index = sharedData.favoritedProducts.firstIndex(where: { product in
            self.product.id == product.id
        }) {
            sharedData.favoritedProducts.remove(at: index)
        } else {
            sharedData.favoritedProducts.append(product)
        }
    }
    
    func addToCart() {
        // Check if the product is already in the cart
        if sharedData.cartProducts.first(where: { $0.id == product.id }) != nil {
            // If the product is already in the cart, do nothing (prevent duplicates)
        } else {
            // If the product is not in the cart, add it with quantity 1
            var newProduct = product
            newProduct.quantity = 1
            sharedData.cartProducts.append(newProduct)
        }
    }
}

public extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
        return formatter
    }()
}

public extension Numeric {
    var formattedWithSeparator: String {
        Formatter.withSeparator.string(for: self) ?? ""
    }
}

struct ProductDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MainPage()
    }
}

@ViewBuilder
func ProductImage(urlString: String) -> some View {
    ProductImageDetailView(urlStrings: [urlString])
}


