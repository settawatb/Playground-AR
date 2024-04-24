//
//  FavoritePage.swift
//  Playground_AR
//
//  Created by Kisses MJ on 29/12/2566 BE.
//

import SwiftUI

struct FavoritePage: View {
    
    @EnvironmentObject var sharedData: SharedDataModel
    
    // Delete Option
    @State var showDeleteOption: Bool = false
    
    var body: some View {
        
        NavigationView{
            
            VStack(spacing: 10) {
                ScrollView(.vertical, showsIndicators: false) {
                    
                    VStack{
                        
                        HStack{
                            Text("Favorite")
                                .font(.custom(customFontBold, size: 40))
                            
                            Spacer()
                            
                            Button {
                                
                                withAnimation{
                                    showDeleteOption.toggle()
                                }
                                
                            } label: {
                                Image("Delete")
                                    .resizable()
                                    .colorMultiply(.red)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 25, height: 25)
                            }
                            .opacity(sharedData.favoritedProducts.isEmpty ? 0 : 1)
                        }
                        
                        // checking if favorited product are empty
                        if sharedData.favoritedProducts.isEmpty{
                            
                            Group{
                                Image("astronaut_3")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .padding()
                                    .padding(.top,35)
                                
                                Text("No Items added")
                                    .font(.custom(customFont, size: 25))
                                    .fontWeight(.semibold)
                                
                                Text("Hit the ❤️ button to save into Favorite.")
                                    .font(.custom(customFont, size: 18))
                                    .foregroundColor(.gray)
                                    .padding(.horizontal)
                                    .padding(.top, 10)
                                    .multilineTextAlignment(.center)
                            }
                            
                        }
                        else {
                            
                            // Displaying Products
                            VStack(spacing: 15){
                                
                                ForEach($sharedData.favoritedProducts){$product in
                                    
                                    HStack(spacing: 0){
                                        
                                        if showDeleteOption{
                                            
                                            Button {
                                                deleteProduct(product: product)
                                            } label: {
                                                Image(systemName: "minus.circle.fill")
                                                    .font(.title2)
                                                    .foregroundColor(.red)
                                            }
                                            .padding(.trailing)
                                        }
                                        CardView(product: product)
                                    }
                                }
                            }
                            .padding(.top, 25)
                            .padding(.horizontal)
                            
                        }
                    }
                    .padding()
                }
            }
            .navigationBarHidden(true)
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
            .background(
                
                Color(LightGray)
                    .ignoresSafeArea()
            
            )
        }
    }
    
    @ViewBuilder
    func CardView(product: Product)->some View{
        HStack(spacing: 15){
            ProductImageView(urlString: product.productImage)
                .frame(width: 100, height: 100)
                .cornerRadius(15)
            
            VStack(alignment: .leading, spacing: 8) {
                
                Text(product.title)
                    .font(.custom(customFont, size: 18).bold())
                    .lineLimit(2)
                
                Text(product.description)
                    .font(.custom(customFont, size: 17))
                    .lineLimit(2)
                    .fontWeight(.semibold)
                    .foregroundColor(PurPle)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            Color.white
                .cornerRadius(10)
            
        )
    }
    
    
    
    func deleteProduct(product: Product){
        
        if let index = sharedData.favoritedProducts.firstIndex(where: {
            currentProduct in
            return product.id == currentProduct.id
            
        }){
            let _ = withAnimation{
                // removing
                sharedData.favoritedProducts.remove(at: index)
            }
        }
        
    }
}

#Preview {
    FavoritePage()
        .environmentObject(SharedDataModel())
}
