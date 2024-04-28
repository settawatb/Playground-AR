//
//  MyProductView.swift
//  Playground_AR
//
//  Created by Kisses MJ on 26/4/2567 BE.
//

import SwiftUI

struct MyProductView: View {
    var body: some View {
        ScrollView {
            MyProductCard()
            MyProductCard()
            MyProductCard()
        }
        .padding(.top,15)
        .background(.white)
    }
}

struct MyProductCard: View{
    
    
    var body: some View{
        Button(action: {
            
        }, label: {
            VStack{
                HStack(spacing: 15){
                    //            ProductImageView(urlString: product.productImage)
                    Image("product_4_green_man")
                        .resizable()
                        .frame(width: 100,height: 100)
                        .cornerRadius(6)
                        .shadow(radius: 4, x:4, y:4)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        // product.title
                        Text("Sample")
                            .font(.custom(customFontBold, size: 18).bold())
                            .lineLimit(2)
                            .foregroundColor(PurPle)
                        // product.description
                        Text("Arttoy")
                            .font(.custom(customFont, size: 14))
                            .lineLimit(2)
                            .foregroundColor(.black)
                        
                        // Quantity Buttons
                        Text("Amount: 12")
                            .font(.custom(customFont, size: 14))
                            .lineLimit(2)
                            .foregroundColor(.black)
                    }
                    
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment:  .leading)
                .background(
                    Color(.white)
                        .cornerRadius(18)
                )
            }
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(style: StrokeStyle(lineWidth: 2))
                    .foregroundColor(.black.opacity(0.2))
            )
            .padding(.horizontal)
            .padding(.vertical,8)
            
        })
    }
    
}

#Preview {
    MyProductView()
}
