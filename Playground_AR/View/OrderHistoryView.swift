//
//  OrderHistoryView.swift
//  Playground_AR
//
//  Created by Settawat Buddhakanchana on 24/4/2567 BE.
//

import SwiftUI

struct OrderHistoryView: View {
    @EnvironmentObject var sharedData: SharedDataModel
    // Status Order
    @State private var orderStatus: [String] = ["Waiting For Payment", "Currently Shipping", "Successful"]
    var body: some View {
        ScrollView{
            VStack(spacing:0) {
                OrderHistoryCardView(orderStatus: orderStatus[0])
                OrderHistoryCardView(orderStatus: orderStatus[1])
                OrderHistoryCardView(orderStatus: orderStatus[2])
            }
        }.background(.white)
    }
}

@ViewBuilder
func OrderHistoryCardView(orderStatus: String) -> some View {
    Button {
        // action to product detail
    } label: {
        VStack(spacing:0){
            // Order Card
            VStack(spacing:0){
                VStack{
                    Text("Order number :  2404022K09Y7F5F")
                        .font(.custom(customFont, size: 16))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    HStack {
                        Text("02/04/2024 20:23")
                            .font(.custom(customFont, size: 16))
                        
                        Text(orderStatus)
                            .font(.custom(customFont, size: 16))
                            .foregroundColor(
                                orderStatus == "Waiting For Payment" ? .yellow :
                                orderStatus == "Currently Shipping" ? .blue :
                                orderStatus == "Successful" ? .green :
                                .black
                            )

                        
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal)
                .frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                .background(.black)
            }
                VStack{
                    Text("Tracking number :  79489930")
                        .font(.custom(customFont, size: 16))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                Divider()
            
            HStack(spacing:0){
                // Image
                Image("product_4_green_man")
                    .resizable()
                    .frame(width: 100,height: 100)
                    .shadow(radius: 1, x: 1, y:1)
                VStack{
                    //Product Name "name"
                    Text("Product Name KEYCHAIN 3D BLINDBOX")
                        .lineLimit(2)
                        .font(.custom(customFont, size: 16))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                    Spacer()
                    HStack{
                        // Product Price "฿ : {price} THB"
                    Text("฿ : 300 THB")
                        .font(.custom(customFont, size: 16))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        Spacer()
                        // Product Quantity "x {quantity}"
                        Text("x 2")
                            .font(.custom(customFont, size: 16))
                            .foregroundColor(.black)
                    }
                }
                .frame(alignment: .leading)
                .padding(.leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            Divider()
                .frame(height: 0.6)
                .overlay(.black.opacity(0.4))
                .shadow(radius: 10)
        }
    }
}

#Preview {
    OrderHistoryView()
}
