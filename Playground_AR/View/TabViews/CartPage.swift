// CartPage.swift
//  Playground_AR
//
//  Created by Settawat Buddhakanchana on 25/12/2566 BE.
//

import SwiftUI



struct CartPage: View {
    
    @EnvironmentObject var sharedData: SharedDataModel
    
    // Delete Option
    @State var showDeleteOption: Bool = false
    
    var body: some View {
        
        NavigationView{
            
            VStack(spacing: 10) {
                ScrollView(.vertical, showsIndicators: false) {
                    
                    VStack{
                        
                        HStack{
                            Text("Cart")
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
                            .opacity(sharedData.cartProducts.isEmpty ? 0 : 1)
                        }
                        
                        // checking if cart product are empty
                        if sharedData.cartProducts.isEmpty{
                            
                            Group{
                                Image("logo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .padding()
                                    .padding(.top,35)
                                
                                Text("No Items added")
                                    .font(.custom(customFont, size: 25))
                                    .fontWeight(.semibold)
                                
                                Text("Hit the button to save into Cart.")
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
                                
                                ForEach($sharedData.cartProducts){$product in
                                    
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
                                        CartView(product: $product)
                                    }
                                }
                            }
                            .padding(.top, 25)
                            .padding(.horizontal)
                            
                        }
                    }
                    .padding()
                }
                
                // Showing Total and check out Button
                if !sharedData.cartProducts.isEmpty{
                    
                    Group{
                        
                        HStack{
                            
                            Text("Total")
                                .font(.custom(customFont, size: 14))
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            Text(sharedData.getTotalPrice())
                                .font(.custom(customFont, size: 18).bold())
                                .foregroundColor(PurPle)
                        }
                        Button {
                            
                        } label: {
                            
                            Text("Checkout")
                                .font(.custom(customFont, size: 18).bold())
                                .foregroundColor(.white)
                                .padding(.vertical,18)
                                .frame(maxWidth: .infinity)
                                .background(Color(PurPle))
                                .cornerRadius(15)
                                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
                        }
                        .padding(.vertical)
                    }
                    .padding(.horizontal, 25)
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
    
    func deleteProduct(product: Product){
        
        if let index = sharedData.cartProducts.firstIndex(where: {
            currentProduct in
            return product.id == currentProduct.id
            
        }){
            let _ = withAnimation{
                // removing
                sharedData.cartProducts.remove(at: index)
            }
        }
        
    }
}


struct CartView: View{
    
    // Making Product as Binding to update real time
    @Binding var product: Product
    
    var body: some View{
        
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
                
                // Quantity Buttons
                HStack(spacing: 10){
                    Text("Quantity")
                        .font(.custom(customFont, size: 14))
                        .foregroundColor(.gray)

                    Button {
                        if product.quantity ?? 0 > 0 {
                            product.quantity! -= 1
                        }
                    } label: {
                        Image(systemName: "minus")
                            .font(.caption)
                            .foregroundColor(.white)
                            .frame(width: 20, height: 20)
                            .background(Color(.red))
                            .cornerRadius(20)
                    }

                    Text ("\(product.quantity ?? 0)")
                        .font(.custom(customFont, size: 14))
                        .fontWeight(.semibold)
                        .foregroundColor(.black)

                    Button {
                        product.quantity! += 1
                    } label: {
                        Image(systemName: "plus")
                            .font(.caption)
                            .foregroundColor(.white)
                            .frame(width: 20, height: 20)
                            .background(Color(PurPle))
                            .cornerRadius(20)
                    }
                }
            }
            
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 10)
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment:  .leading)
        .background(
            Color(.white)
                .cornerRadius(18)
        )
        
    }
}

struct CartPage_Previews: PreviewProvider {
    static var previews: some View {
        CartPage()
            .environmentObject(SharedDataModel()) // Provide a sample environment object
    }
}
