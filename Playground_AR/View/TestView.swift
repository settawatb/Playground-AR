//
//  TestView.swift
//  Playground_AR
//
//  Created by Settawat Buddhakanchana on 30/4/2567 BE.
//

import SwiftUI

struct TestView: View {
    var body: some View {
        VStack{
            HStack(spacing: 5){
                Image("product_1_kaws")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("KAWS X PEANUTS JOE KAWS")
                        .font(.custom(customFontBold, size: 24))
                        .lineLimit(1)
                        .shadow(color: Color.black.opacity(0.03), radius: 1, x: 5, y: 5)
                    
                    HStack{
                        Text("Art toys")
                            .font(.custom(customFont, size: 18))
                            .lineLimit(2)
                            .padding(.vertical,5)
                            .padding(.horizontal,12)
                            .overlay(
                                Capsule()
                                    .stroke(PurPle, lineWidth: 2)
                                
                            )
                        Spacer()
                        Text("Seller : test")
                            .font(.custom(customFont, size: 18))
             
                    }
                    HStack{
                        
                        Text("12,000 THB")
                            .font(.custom(customFont, size: 18))
                            .lineLimit(2)
                        Spacer()
                        Text("Quantity : 10")
                            .font(.custom(customFont, size: 18))
                        
                    }
                    
                }.padding(.horizontal,10)
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LightGray)
            
    }
}

#Preview {
    TestView()
}
