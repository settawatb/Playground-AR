//
//  SearchView.swift
//  Playground_AR
//
//  Created by Settawat Buddhakanchana on 24/12/2566 BE.
//

import SwiftUI

struct SearchView: View {
    var animation: Namespace.ID
    
    // SharedData
    @EnvironmentObject var sharedData: SharedDataModel
    
    @EnvironmentObject var homeData: HomeViewModel
    
    //Activating Text Field with the help of FocusState
    @FocusState var startTF: Bool
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            // Search Bar
            HStack(spacing: 20){
                
                // Close Button
                Button {
                    withAnimation{
                        homeData.searchActivated = false
                    }
                    homeData.searchText = ""
                    // Resetting
                    sharedData.fromSearchPage = false
                    
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(Color.black.opacity(0.7))
                }
                
                // Search Bar
                HStack(spacing: 15) {
                    Image(systemName: "magnifyingglass")
                        .font(.title2)
                        .foregroundColor(.gray)
                    
                    // Seperate View for search bar
                    TextField("Search", text:
                                $homeData.searchText)
                        .focused($startTF)
                        .textCase(.lowercase)
                        .disableAutocorrection(true)
                }
                .padding(.vertical, 12)
                .padding(.horizontal)
                .background(
                    Capsule()
                        .strokeBorder(PurPle, lineWidth: 1.5)
                )
                .matchedGeometryEffect(id: "SEARCHBAR", in:animation)
                .padding(.trailing,20)
            }
            .padding([.horizontal])
            .padding(.top)
            .padding(.bottom,10)
            
            // Showing Progress if searching
            // else showing no results found if empty
            if let products = homeData.searchedProducts{
                
                if products.isEmpty{
                    
                    // No Results Found
                    VStack(spacing: 0){
                        
                        Image("logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        Text("Item Not Found")
                            .font(.custom(customFont, size: 22).bold())
                        Text("Try a more generic search term or try looking for alternative products.")
                            .font(.custom(customFont, size: 16))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)
                    }
                    .padding()
                }
                else{
                    // Filter Results
                    ScrollView(.vertical, showsIndicators: false) {
                        
                        VStack(spacing: 0){
                            
                            // Found Text
                            Text("Found \(products.count) results")
                                .font(.custom(customFont, size:24).bold())
                                .padding(.vertical)
                            
                            // Staggered Grid
                            StaggeredGrid(columns: 2, spacing:20,  list: products) {
                                product in
                                
                                // Card View
                                ProductCardView(product: product)
                            }
                        }
                        .padding()
                    }
                }
                
            }
            else{
                
                ProgressView()
                    .padding(.top, 30)
                    .opacity(homeData.searchText == "" ? 0 : 1)
            }
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .top)
        .background(
            Color.white
                .ignoresSafeArea()
        
        )
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                startTF = true
            }
        }
    }
    
    @ViewBuilder
    func ProductCardView(product: Product) -> some View {
        HStack() {
            VStack(spacing: 1) {
                
                ZStack{
                    if sharedData.showDetailProduct{
                        AsyncImage(url: URL(string: product.productImage)) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .opacity(0)
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
                    else{
                        AsyncImage(url: URL(string: product.productImage)) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .matchedGeometryEffect(id: "\(product.id)SEARCH", in: animation)
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
                }
                
                Text(product.title)
                    .lineLimit(2)
                    .font(.custom(customFont, size: 18))
                    .frame(width: getRect().width / 2 - 40, alignment: .leading)
                    .fontWeight(.semibold)
                    .padding(.top)
                
                Text(product.description)
                    .lineLimit(2)
                    .font(.custom(customFont, size: 14))
                    .frame(width: getRect().width / 2 - 40, alignment: .leading)
                    .foregroundStyle(.gray)
                    
                
                Text(product.price + " บาท")
                    .font(.custom(customFont, size: 16))
                    .fontWeight(.bold)
                    .frame(width: getRect().width / 2 - 40, alignment: .leading)
                    .foregroundStyle(Color(red: 125/255, green: 122/255, blue: 255/255))
                    .padding(.top, 5)
            }
            .background(
                Color.white
                    .opacity(0.2)
                    .cornerRadius(25)
            )
            .onTapGesture{
                
                withAnimation(.easeInOut){
                    sharedData.fromSearchPage = true
                    sharedData.detailProduct = product
                    sharedData.showDetailProduct = true
                }
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View{
        MainPage()
    }
}
