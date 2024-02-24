//
//  Home.swift
//  Playground_AR
//
//  Created by Settawat Buddhakanchana on 4/12/2566 BE.
//


import SwiftUI

struct Home: View {
    var animation: Namespace.ID
    
    // Shared Data
    @EnvironmentObject var sharedData: SharedDataModel
    
    @StateObject var homeData: HomeViewModel = HomeViewModel()
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 15) {
                Text("Discovery")
                    .font(.custom(customFont, size: 28).bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top)
                    .padding(.horizontal, 25)
                
                // Search Bar
                ZStack{
                    if homeData.searchActivated{
                        SearchBar()
                    }
                    else {
                        SearchBar()
                            .matchedGeometryEffect(id: "SEARCHBAR", in: animation)
                    }
                }
                .frame(width: getRect().width / 1.6)
                .padding(.horizontal, 25)
                .contentShape(Rectangle())
                .onTapGesture{
                    withAnimation(.easeInOut){
                        homeData.searchActivated = true
                    }
                }
                
                // Product Tab
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 18) {
                        ForEach(ProductType.allCases, id: \.self) { type in
                            // Product Type View
                            ProductTypeView(type: type)
                        }
                    }
                    .padding(.horizontal, 25)
                }
                
                // Products Page
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: Array(repeating: GridItem(), count: 2), spacing: 10) {
                        ForEach(homeData.filteredProducts.chunked(into: 2), id: \.self) { row in
                            ForEach(row) { product in
                                // Product View Card
                                ProductCardView(product: product)
                            }
                        }
                    }
                    .padding(.horizontal, 25)
                    .padding(.bottom) 
                }
            }
            .padding(.vertical)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        // Updating data whenever tab changes
        .onChange(of: homeData.productType) { _, _ in
            homeData.filterProductByType()
        }
        
        // Displaying Search View
        .overlay(
            ZStack{
                if homeData.searchActivated{
                    SearchView(animation: animation)
                        .environmentObject(homeData)
                }
            }
        )
    }
    
    @ViewBuilder
    func SearchBar() -> some View {
        // Search Bar
        HStack(spacing: 15) {
            Image(systemName: "magnifyingglass")
                .font(.title2)
                .foregroundColor(.gray)
            
            // Search Bar
            TextField("Search", text: .constant(""))
                .disabled(true)
        }
        .padding(.vertical, 12)
        .padding(.horizontal)
        .background(
            Capsule()
                .strokeBorder(Color.gray, lineWidth: 0.8)
        )
    }
    
    @ViewBuilder
    func ProductCardView(product: Product) -> some View {
        HStack {
            VStack(spacing: 1) {
                ProductImage(urlString: product.productImage)
                ProductDetails(product: product)
                ProductPrice(product: product)
            }
            .onTapGesture {
                withAnimation(.easeInOut) {
                    sharedData.detailProduct = product
                    sharedData.showDetailProduct = true
                }
            }
        }
    }

    @ViewBuilder
    func ProductImage(urlString: String) -> some View {
        AsyncImage(url: URL(string: urlString)) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: getRect().width / 2 - 40, height: getRect().width / 2 - 40)
                    .cornerRadius(15)
                    .shadow(radius: 5)
                    .offset(y: 20)
                    .padding(.bottom, 20)
                    .fixedSize(horizontal: true, vertical: false)
            case .failure:
                Image("image_placeholder") // Placeholder image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: getRect().width / 2 - 40, height: getRect().width / 2 - 40)
                    .cornerRadius(15)
                    .shadow(radius: 5)
                    .offset(y: 20)
                    .padding(.bottom, 20)
                    .fixedSize(horizontal: true, vertical: false)
            case .empty:
                Image("image_placeholder") // Placeholder image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: getRect().width / 2 - 40, height: getRect().width / 2 - 40)
                    .cornerRadius(15)
                    .shadow(radius: 5)
                    .offset(y: 20)
                    .padding(.bottom, 20)
                    .fixedSize(horizontal: true, vertical: false)
            @unknown default:
                Image("image_placeholder") // Placeholder image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: getRect().width / 2 - 40, height: getRect().width / 2 - 40)
                    .cornerRadius(15)
                    .shadow(radius: 5)
                    .offset(y: 20)
                    .padding(.bottom, 20)
                    .fixedSize(horizontal: true, vertical: false)
            }
        }
    }



    
    @ViewBuilder
    func ProductDetails(product: Product) -> some View {
        // Product Details
        Text(product.title)
            .font(.custom(customFont, size: 18))
            .frame(width: getRect().width / 2 - 40, alignment: .leading)
            .fontWeight(.semibold)
            .padding(.top)
            .lineLimit(1)
        
        Text(product.description)
            .lineLimit(1)
            .font(.custom(customFont, size: 14))
            .frame(width: getRect().width / 2 - 40, alignment: .leading)
            .foregroundStyle(.gray)
    }
    
    @ViewBuilder
    func ProductPrice(product: Product) -> some View {
        // Product Price
        Text((Int(product.price) ?? 0).formattedWithSeparator + " THB")
            .font(.custom(customFont, size: 16))
            .fontWeight(.bold)
            .frame(width: getRect().width / 2 - 40, alignment: .leading)
            .foregroundStyle(Color(red: 125/255, green: 122/255, blue: 255/255))
            .padding(.top, 5)
    }
    
    @ViewBuilder
    func ProductTypeView(type: ProductType) -> some View {
        Button {
            // Updating Current Type
            withAnimation {
                homeData.productType = type
            }
        } label: {
            Text(type.rawValue)
                .font(.custom(customFont, size: 15))
                .fontWeight(.semibold)
                .foregroundColor(homeData.productType == type ? PurPle : Color.gray)
                .padding(.bottom, 10)
                .overlay(
                    ZStack {
                        if homeData.productType == type {
                            Capsule()
                                .fill(Color(red: 125/255, green: 122/255, blue: 255/255))
                                .frame(height: 2)
                        } else {
                            Capsule()
                                .fill(Color.clear)
                                .frame(height: 2)
                        }
                    }
                    .padding(.horizontal, -5),
                    alignment: .bottom
                )
        }
    }
}

// Extending View to get Screen Bounds
extension View {
    func getRect() -> CGRect {
        return UIScreen.main.bounds
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        MainPage()
    }
}
