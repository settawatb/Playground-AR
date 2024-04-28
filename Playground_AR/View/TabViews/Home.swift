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
            VStack(spacing: 0) {
                HStack(spacing: 15){
                    Text("Discovery")
                        .font(.custom(customFontBold, size: 40))
                        
                    Spacer()
                    
                    // Search Bar
                    ZStack {
                        if homeData.searchActivated {
                            SearchBar()
                                .transition(.opacity)
                        } else {
                            SearchBar()
                                .matchedGeometryEffect(id: "SEARCHBAR", in: animation)
                                .transition(.opacity)
                        }
                    }
                    .frame(width: getRect().width / 3)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation {
                            homeData.searchActivated.toggle()
                        }
                    }
                }.padding(.horizontal)
                    .padding(.vertical)
                
                
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
                Divider()
                    .background(Color.black.opacity(0.4))
                
                // Products Page
                ScrollView(showsIndicators: false) {
                    VStack {
                        // Calculate the range of products to display on the current page
                        let startIndex = homeData.currentPage * homeData.productsPerPage
                        let endIndex = min(startIndex + homeData.productsPerPage, homeData.filteredProducts.count)
                        
                        // Display products for the current page
                        LazyVGrid(columns: Array(repeating: GridItem(), count: 2), spacing: 10) {
                            ForEach(homeData.filteredProducts[startIndex..<endIndex], id: \.self) { product in
                                ProductCardView(product: product)
                            }
                        }
                        .padding(.horizontal, 25)
                        .padding(.vertical)
                    }
                }
                Divider()
                    .background(Color.black.opacity(0.4))
                // Page Button
                HStack {
                    // Previous page button
                    Button(action: {
                        if homeData.currentPage > 0 {
                            homeData.currentPage -= 1
                        }
                    }) {
                        Image(systemName: "arrowshape.left.fill")
                            .resizable()
                            .frame(width: 33,height: 24)
                            .scaledToFit()
                            .foregroundColor(homeData.currentPage > 0 ? PurPle : .gray)
                            .padding(.horizontal, 12)
                    }
                    .disabled(homeData.currentPage == 0) // Disable button if on first page

                    Spacer()

                    // Page numbers
                    ForEach(0..<(homeData.filteredProducts.count / homeData.productsPerPage + (homeData.filteredProducts.count % homeData.productsPerPage == 0 ? 0 : 1)), id: \.self) { index in
                        Text("\(index + 1)")
                            .font(.custom(customFont, size: 15))
                            .foregroundColor(homeData.currentPage == index ? .white : .gray)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                Circle()
                                    .stroke(homeData.currentPage == index ? PurPle : .gray, lineWidth: 1)
                                    .fill(homeData.currentPage == index ? PurPle : .clear)
                            )
                            .onTapGesture {
                                homeData.currentPage = index
                            }
                    }

                    Spacer()

                    // Next page button
                    Button(action: {
                        if homeData.currentPage < homeData.filteredProducts.count / homeData.productsPerPage {
                            homeData.currentPage += 1
                        }
                    }) {
                        
                        Image(systemName: "arrowshape.right.fill")
                            .resizable()
                            .frame(width: 33,height: 24)
                            .scaledToFit()
                            .foregroundColor(homeData.currentPage < homeData.filteredProducts.count / homeData.productsPerPage ? PurPle : .gray)
                            .padding(.horizontal, 12)
                    }
                    .disabled(homeData.currentPage >= homeData.filteredProducts.count / homeData.productsPerPage) // Disable button if on last page
                }
                .padding(.horizontal, 25)
                .padding(.vertical, 10)


            }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        // Updating data whenever tab changes
        .onChange(of: homeData.productType) { _, _ in
            homeData.filterProductByType()
        }
        .onAppear {
            homeData.fetchProductsFromAPI()
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
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .font(.title2)
                .foregroundColor(.gray)
            
            // Search Bar
            TextField("Search", text: .constant(""))
                .font(.custom(customFont, size: 15))
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
            VStack(spacing: 10) {
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
//                    .frame(width: getRect().width / 2 - 40, height: getRect().width / 2 - 40)
                    .frame(width: 170,height: 170)
                    .cornerRadius(15)
                    .shadow(radius: 3)
                    .offset(y: 20)
                    .padding(.bottom, 7)
                    .fixedSize(horizontal: true, vertical: false)
            case .failure:
                Image("image_placeholder") // Placeholder image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 170,height: 170)
                    .cornerRadius(15)
                    .shadow(radius: 5)
                    .offset(y: 20)
                    .padding(.bottom, 7)
                    .fixedSize(horizontal: true, vertical: false)
            case .empty:
                Image("image_placeholder") // Placeholder image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 170,height: 170)
                    .cornerRadius(15)
                    .shadow(radius: 5)
                    .offset(y: 20)
                    .padding(.bottom, 7)
                    .fixedSize(horizontal: true, vertical: false)
            @unknown default:
                Image("image_placeholder") // Placeholder image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 170,height: 170)
                    .cornerRadius(15)
                    .shadow(radius: 5)
                    .offset(y: 20)
                    .padding(.bottom, 7)
                    .fixedSize(horizontal: true, vertical: false)
            }
        }
    }



    
    @ViewBuilder
    func ProductDetails(product: Product) -> some View {
        // Product Details
        VStack(alignment:.leading, spacing: 0){
            Text(product.title)
//                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .font(.custom(customFont, size: 20))
                .fontWeight(.semibold)
                .padding(.top)
                .lineLimit(1)
            HStack {
                Text(product.type[0].rawValue)
                    .lineLimit(1)
                    .font(.custom(customFont, size: 14))
                    .foregroundStyle(.gray)
                if let quantity = product.quantity {
                    Text("Qty : \(quantity)")
                        .lineLimit(1)
                        .font(.custom(customFont, size: 14))
                        .foregroundStyle(.gray)
                }
            }
            Text((Int(product.price) ?? 0).formattedWithSeparator + " THB")
                .font(.custom(customFont, size: 16))
                .fontWeight(.bold)
                .frame(width: getRect().width / 2 - 40, alignment: .leading)
                .foregroundStyle(Color(red: 125/255, green: 122/255, blue: 255/255))
        }
        .padding(0)
//        .padding(.horizontal,10)
//        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder
    func ProductPrice(product: Product) -> some View {
        // Product Price
//        Text((Int(product.price) ?? 0).formattedWithSeparator + " THB")
//            .font(.custom(customFont, size: 16))
//            .fontWeight(.bold)
//            .frame(width: getRect().width / 2 - 40, alignment: .leading)
//            .foregroundStyle(Color(red: 125/255, green: 122/255, blue: 255/255))
//            .padding(.top, 5)
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
