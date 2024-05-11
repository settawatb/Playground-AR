//
//  ProductDetailView.swift
//  Playground_AR
//
//  Created by Settawat Buddhakanchana on 25/12/2566 BE.
//

import SwiftUI
import PopupView


struct ProductDetailView: View {
    var product: Product
    var animation: Namespace.ID
    @EnvironmentObject var sharedData: SharedDataModel
    @EnvironmentObject var homeData: HomeViewModel
    @StateObject var loginData: LoginPageModel = LoginPageModel()
    @State private var isShowingARModeView: Bool = false
    @State private var modelPlacement: Bool = false
    @State private var isLoading: Bool = false
    @State var showingPopup = false
    @State var showingPopup2 = false
    @State var toggleFav = false
    @State private var isFullScreenImagePresented: Bool = false
    
    
    var body: some View {
        VStack(spacing: 0) {
            titleBarAndProductImage
            
            productDetailsScrollView
            
            buttonsView
        }
        .onAppear {
            loginData.fetchUserProfile()
        }
        .padding(.top, 20)
//        .background(.red)
        .ignoresSafeArea()
        .onTapGesture {
            hideKeyboard()
        }
        .popup(isPresented: $showingPopup) {
        
            VStack(alignment:.center,spacing:0){
                HStack(spacing:30){
                    Image(systemName: "cart.fill.badge.plus")
                        .resizable()
                        .frame(width: 40, height: 32)
                        .symbolEffect(
                            .bounce.up.byLayer,value: showingPopup
                        )
                    VStack(alignment: .leading) {
                        Text(product.title)
                            .lineLimit(1)
                        Text("Added To Cart")
                    }
                }
                .padding()
                .font(.custom(customFontBold, size: 15))
                    .foregroundStyle(.white)
                    .frame(width: 300, height: 60)
                    .background(PurPle)
                    .cornerRadius(20)
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
    } customize: {
        $0
            .autohideIn(2)
            .type(.floater())
            .position(.top)
            .animation(.spring())
            .closeOnTapOutside(true)
//            .isOpaque(true)
    }
        .popup(isPresented: $showingPopup2) {
    
        VStack(alignment:.center,spacing:0){
            HStack(spacing:30){
                if toggleFav == true {
                    Image(systemName: "heart.fill")
                        .resizable()
                        .frame(width: 35, height: 32)
                        .foregroundColor(.red)
                }else {
                    Image(systemName: "heart.slash.fill")
                        .resizable()
                        .frame(width: 35, height: 32)
                        .foregroundColor(.red)
                }
                VStack(alignment: .leading){
                    if toggleFav == true {
                        Text(product.title)
                            .lineLimit(1)
                        Text("Added To Favorite")
                    }else {
                        Text(product.title)
                            .lineLimit(1)
                        Text("Remove From Favorite")
                    }
                }
            }
            .padding()
            .font(.custom(customFontBold, size: 15))
                .foregroundStyle(.white)
                .frame(width: 300, height: 60)
                .background(PurPle)
                .cornerRadius(20)
    }
    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
} customize: {
    $0
        .autohideIn(2)
        .type(.floater())
        .position(.top)
        .animation(.spring())
        .closeOnTapOutside(true)
//            .isOpaque(true)
}
        .animation(.easeInOut, value: sharedData.favoritedProducts)
        .animation(.easeInOut, value: sharedData.cartProducts)
        .background(LightGray.ignoresSafeArea())
        .fullScreenCover(isPresented: $isFullScreenImagePresented) {
            let imageUrls = product.productImages.compactMap { URL(string: $0) }

            if !imageUrls.isEmpty {
                FullScreenImageView(imageUrls: imageUrls, isPresented: $isFullScreenImagePresented)
            } else {
                Text("Failed to load image URLs")
                    .font(.headline)
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
            }
        }


    }

    // Separate the title bar and product image into its own view
    private var titleBarAndProductImage: some View {
        VStack {
            titleBar
            productImageView
                .onTapGesture {
                    isFullScreenImagePresented = true
                }
        }
        .padding(.top)
        .zIndex(1)
    }

    // View for the title bar
    private var titleBar: some View {
        HStack {
            Button {
                // Close the view
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
                showingPopup2 = true
                toggleFav = !toggleFav
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
    }

    // View for the product image
    private var productImageView: some View {
            ProductImageDetailView(urlStrings: product.productImages)
                .matchedGeometryEffect(id: "\(product.id)\(sharedData.fromSearchPage ? "SEARCH" : "IMAGE")", in: animation)
                .padding(.horizontal, 5)
                .offset(y: -16)
                .frame(maxHeight: .infinity)
        }

    // Separate the product details scroll view into its own view
    private var productDetailsScrollView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            productDetailsView
        }
        .zIndex(1)
        .background(Color.white)
        .clipShape(CustomCorners(corners: [.topLeft, .topRight], radius: 25))
    }

    // View for the product details
    private var productDetailsView: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(product.title)
                .font(.custom(customFontBold, size: 35))
            
            let formattedDate = DateFormatter.dayMonthYear.string(from: product.updateAt)
            
            Text(product.type[0].rawValue)
                .font(.custom(customFont, size: 20))
                .lineLimit(1)
                .padding(.vertical, 1)
                .padding(.horizontal, 10)
                .overlay(
                    Capsule()
                        .stroke(PurPle, lineWidth: 2)
                )
                .padding(.bottom, 3)
            
            HStack {
                Text("Seller: ")
                    .font(.custom(customFontBold, size: 15))
                    .foregroundStyle(Color.black)
                    +
                Text(product.productSeller.sellerName)
                    .font(.custom(customFont, size: 15))
                    .foregroundStyle(Color.black)
                    +
                Text("   Stock: ")
                    .font(.custom(customFontBold, size: 15))
                    .foregroundStyle(Color.black)
                    +
                Text("\(product.quantity ?? 1)")
                    .font(.custom(customFont, size: 15))
                    .foregroundStyle(Color.gray)
            }
            
            Text("Update Date: ")
                .font(.custom(customFontBold, size: 15))
                .foregroundStyle(Color.black)
                +
            Text(formattedDate)
                .font(.custom(customFont, size: 15))
                .foregroundStyle(Color.gray)
            
            Text("Ships from: ")
                .font(.custom(customFontBold, size: 15))
                .foregroundStyle(Color.black)
                +
            Text(product.productSeller.sellerAddress)
                .font(.custom(customFont, size: 15))
                .foregroundStyle(Color.gray)
            
            Text("Detail")
                .font(.custom(customFontBold, size: 15))
                .foregroundStyle(Color.black)
            Text(product.description)
                .font(.custom(customFont, size: 16))
                .foregroundStyle(Color.gray)
        }
        .padding([.horizontal, .top])
    }
    
    // Separate the buttons view into its own view
    private var buttonsView: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading) {
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
                    ARModeView(
                        modelPlacement: $modelPlacement,
                        isLoading: $isLoading,
                        productTitle: product.title,
                        model3DURL: product.productModel
                    )
                }

                
                Button {
                    if loginData.userName != product.productSeller.sellerName {
                        addToCart()
                        showingPopup = true
                    }
                } label: {
                    Group {
                        if loginData.userName == product.productSeller.sellerName {
                            Text("You are the owner of this product")
                                .font(.custom(customFont, size: 16).bold())
                        } else {
                            Text(isAddedToCart() ? "Added to cart" : "Add to cart")
                                .font(.custom(customFont, size: 20).bold())
                        }
                    }
                    .foregroundColor(Color.white)
                    .padding(.vertical, 20)
                    .frame(maxWidth: .infinity)
                    .background(
                        // Set background color based on the condition
                        loginData.userName == product.productSeller.sellerName ? Color(LightGray) : (
                            isAddedToCart() ? PurPle.opacity(0.5) : Color.black
                        )
                    )
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 5, y: 5)
                }

            }
        }
        .padding(30)
        .padding(.bottom,20)
        .zIndex(99)
        .background(.white)
        .clipShape(CustomCorners(corners: [.topLeft, .topRight], radius: 25))
        .shadow(radius: 4)
    }
    
    // Helper functions
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


struct FullScreenImageView: View {
    var imageUrls: [URL]
    @Binding var isPresented: Bool
    @State private var currentIndex: Int = 0
    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero

    var body: some View {
        ZStack {
            // Image slider with TabView
            TabView(selection: $currentIndex) {
                ForEach(imageUrls.indices, id: \.self) { index in
                    ZoomableScrollView2(content: AsyncImage(url: imageUrls[index]) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .scaleEffect(scale)
                                .offset(offset)
                                .gesture(
                                    MagnificationGesture()
                                        .onChanged { value in
                                            let newScale = scale * value.magnitude
                                            scale = min(max(1.0, newScale), 3.0)
                                        }
                                )
                                .gesture(
                                    DragGesture()
                                        .onChanged { value in
                                            offset = value.translation
                                        }
                                        .onEnded { _ in
                                            offset = .zero
                                        }
                                )
                        case .failure:
                            Image("image_placeholder")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        default:
                            ProgressView()
                        }
                    })
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            VStack {
                HStack {
                    Button(action: {
                        isPresented = false
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.black)
                            .padding()
                            .padding(.top, 70)
                    }
                    Spacer()
                }
                Spacer()
            }
        }
        .background(Color.black)
        .ignoresSafeArea()
    }
}




