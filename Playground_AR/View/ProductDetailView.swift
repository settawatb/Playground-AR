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
        VStack {
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
                Image(product.productImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .matchedGeometryEffect(id: "\(product.id)\(sharedData.fromSearchPage ? "SEARCH" : "IMAGE")", in: animation)
                    .cornerRadius(25)
                    .padding(.horizontal)
                    .offset(y: -12)
                    .frame(maxHeight: .infinity)
            }
            .frame(height: getRect().height / 2.7)
            .zIndex(1)

            // Product Details
            ScrollView(.vertical, showsIndicators: false) {
                // Product Data
                VStack(alignment: .leading, spacing: 15) {
                    Text(product.title)
                        .font(.custom(customFont, size: 20).bold())

                    Text(product.subtitle)
                        .font(.custom(customFont, size: 18))
                        .foregroundStyle(Color.gray)

                    Text("Description of product example")
                        .font(.custom(customFont, size: 16))
                        .foregroundStyle(Color.gray)

                    Button {
                        // Since image at right
                    } label: {
                        Label {
                            Image(systemName: "arrow.right")
                        } icon: {
                            Text("Full Description")
                        }
                        .font(.custom(customFont, size: 15).bold())
                        .foregroundColor(PurPle)
                    }

                    Spacer()
                    VStack(alignment: .leading){
                        Text("Price")
                            .font(.custom(customFont, size: 17))

                        Text((Int(product.price) ?? 0).formattedWithSeparator + " THB")
                            .font(.custom(customFont, size: 20).bold())
                            .foregroundColor(.black)
                    }
                    .padding(.vertical, 20)

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
                            ARModeView()
                                .navigationTitle("AR Mode Title")
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
                                    Color(.black)
                                        .cornerRadius(10)
                                        .shadow(color: Color.black.opacity(0.06), radius: 5, x:5, y:5)
                                )
                        }
                    }
                }
                .padding([.horizontal,.bottom], 25)
                .padding(.top, 25)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .zIndex(0)
            .background(Color.white)
            .clipShape(CustomCorners(corners: [.topLeft, .topRight], radius: 25))
            .ignoresSafeArea()
        }
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
        if let index = sharedData.cartProducts.firstIndex(where: { product in
            self.product.id == product.id
        }) {
            sharedData.cartProducts.remove(at: index)
        } else {
            sharedData.cartProducts.append(product)
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
