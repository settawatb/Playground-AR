//
//  CheckoutView.swift
//  Playground_AR
//
//  Created by Settawat Buddhakanchana on 28/4/2567 BE.
//

import SwiftUI
import Foundation
import PopupView

struct CheckoutView: View {
    @StateObject var loginData: LoginPageModel = LoginPageModel()
    @State var showingPopup = false
    @State private var showAlert: Bool = false
    @State private var navigateToProfilePage: Bool = false
    @EnvironmentObject var sharedData: SharedDataModel
    @Environment(\.presentationMode) var presentationMode
    @Binding var products: [Product]

    init(products: Binding<[Product]>) {
        let appear = UINavigationBarAppearance()
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: customFontBold, size: 20)!
        ]
        appear.largeTitleTextAttributes = attributes
        appear.titleTextAttributes = attributes
        UIBarButtonItem.appearance().tintColor = .black
        UINavigationBar.appearance().standardAppearance = appear
        UINavigationBar.appearance().compactAppearance = appear
        UINavigationBar.appearance().scrollEdgeAppearance = appear
        self._products = products
    }
    
    func calculateTotalPrice(for products: [Product]) -> Double {
        return products.reduce(0.0) { sum, product in
            let price = Double(product.price) ?? 0.0
            let quantity = product.quantity ?? 0
            return sum + (price * Double(quantity))
        } + 15
    }
    
    func formatTotalPrice(_ totalPrice: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        
        if let formattedTotalPrice = numberFormatter.string(from: NSNumber(value: totalPrice)) {
            return formattedTotalPrice
        } else {
            return ""
        }
    }
    
    
    var body: some View {
        
        NavigationView {
            VStack(spacing:0){
                ScrollView{
                    VStack(spacing:0){
                        VStack(alignment:.leading, spacing:0){
                            Text("Shipping address")
                                .font(.custom(customFontBold, size: 16))
                            if !loginData.address.isEmpty {
                                Text(loginData.address)
                                    .lineLimit(3)
                                    .font(.custom(customFont, size: 16))
                            }else{
                                Text("มหาวิทยาลัยรามคำแหง ถนนรามคำแหง หัวหมาก บางกะปิ กรุงเทพมหานคร 10240")
                                    .lineLimit(3)
                                    .font(.custom(customFont, size: 16))
                            }
                            
                            Divider().background(Color.black.opacity(0.4)).padding(.vertical)
                            HStack{
                                Text("Seller").font(.custom(customFontBold, size: 16))
                                Text("Test1").font(.custom(customFont, size: 16))
                            }
                            
                            Divider().background(Color.black.opacity(0.4)).padding(.top)
                            if !products.isEmpty {
                                VStack(spacing:0){
                                    ForEach(products) { product in
                                        HStack(spacing: 15) {
                                            // Product Image and information
                                            ProductImageCheckoutView(urlString: product.productImage)
                                            
                                            VStack(alignment: .leading, spacing: 8) {
                                                Text(product.title)
                                                    .font(.custom(customFont, size: 16).bold())
                                                    .lineLimit(2)
                                                Text("Price per Items: \(product.price)")
                                                    .font(.custom(customFont, size: 16))
                                                    .lineLimit(1)
                                                    .foregroundColor(PurPle)
                                                Text("Amount: \(product.quantity ?? 0) Item")
                                                    .font(.custom(customFont, size: 16))
                                                    .lineLimit(1)
                                                    .foregroundColor(PurPle)
                                            }
                                        }
                                        .padding(20)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(Color.white)
                                        Divider().background(Color.black.opacity(0.4)).padding(.bottom)
                                    }
                                }
                                
                            } else {
                                HStack(spacing: 15) {
                                    // Product Image and information
                                    Image("product_4_green_man")
                                        .resizable()
                                        .frame(width: 100, height: 100)
                                        .cornerRadius(6)
                                        .shadow(radius: 4, x: 4, y: 4)
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Sample Product Name")
                                            .font(.custom(customFont, size: 16).bold())
                                            .lineLimit(2)
                                        Text("example")
                                            .font(.custom(customFont, size: 16))
                                            .lineLimit(2)
                                            .foregroundColor(PurPle)
                                        Text("Quantity: 1")
                                            .font(.custom(customFont, size: 16))
                                            .lineLimit(1)
                                            .foregroundColor(PurPle)
                                    }
                                }
                                .padding(20)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.white)
                                Divider().background(Color.black.opacity(0.4)).padding(.bottom)
                                
                            }
                            Text("Delivery")
                                .font(.custom(customFontBold, size: 16))
                            Text("Standard Delivery")
                                .font(.custom(customFontBold, size: 14))
                                .padding(.top,5)
                            Text("Normal delivery within the country")
                                .font(.custom(customFont, size: 14))
                            Text("You will receive the product within 7 days.")
                                .font(.custom(customFont, size: 13))
                            Divider()
                                .background(Color.black.opacity(0.4))
                                .padding(.vertical)
                            HStack{
                                Text("Message for Sellers ")
                                    .font(.custom(customFontBold, size: 16))
                                Spacer()
                                Text("Leave a message to the seller")
                                    .lineLimit(1)
                                    .font(.custom(customFont, size: 14))
                                    .foregroundStyle(.black.opacity(0.3))
                            }
                            Divider().background(Color.black.opacity(0.4)).padding(.vertical)
                            HStack {
                                if !products.isEmpty {
                                    // Calculate the number of items and total price
                                    let items = products.count
                                    let totalPrice = calculateTotalPrice(for: products)
                                    
                                    Text("Order Total (\(items) Item\(items > 1 ? "s" : ""))")
                                        .font(.custom(customFontBold, size: 16))
                                    Spacer()
                                    let formattedTotalPrice = formatTotalPrice(totalPrice)
                                    Text("฿ \(formattedTotalPrice)")
                                        .font(.custom(customFontBold, size: 16))
                                } else {
                                    Text("Order Total (1 Item)")
                                        .font(.custom(customFontBold, size: 16))
                                    Spacer()
                                    Text("฿ 2,600")
                                        .font(.custom(customFontBold, size: 16))
                                }
                            }
                            
                            Divider().background(Color.black.opacity(0.4)).padding(.vertical)
                            HStack{
                                Text("Shop Voucher")
                                    .font(.custom(customFontBold, size: 16))
                                Spacer()
                                Text("Select Voucher")
                                    .font(.custom(customFont, size: 16))
                                    .foregroundStyle(.black.opacity(0.3))
                            }
                            Divider().background(Color.black.opacity(0.4)).padding(.vertical)
                            HStack{
                                Text("Payment Method")
                                    .font(.custom(customFontBold, size: 16))
                                Spacer()
                                Text("Promptpay QR")
                                    .font(.custom(customFont, size: 16))
                                    .foregroundStyle(.black)
                            }
                            Divider().background(Color.black.opacity(0.4)).padding(.vertical)
                            HStack{
                                let totalPrice = calculateTotalPrice(for: products)
                                Text("Merchandise Subtotal:")
                                    .font(.custom(customFont, size: 16))
                                Spacer()
                                let formattedTotalPrice = formatTotalPrice(totalPrice)
                                Text("฿ \(formattedTotalPrice)")
                                    .font(.custom(customFont, size: 16))
                            }
                            HStack{
                                Text("Shipping Total")
                                    .font(.custom(customFont, size: 16))
                                Spacer()
                                Text("฿ 45")
                                    .font(.custom(customFont, size: 16))
                            }
                            HStack{
                                Text("Discount")
                                    .font(.custom(customFont, size: 16))
                                Spacer()
                                Text("-฿ 30")
                                    .font(.custom(customFont, size: 16))
                            }
                            HStack{
                                let totalPrice = calculateTotalPrice(for: products) + 15
                                let formattedTotalPrice = formatTotalPrice(totalPrice)
                                Text("Total Payment")
                                    .font(.custom(customFontBold, size: 20))
                                Spacer()
                                Text("฿ \(formattedTotalPrice)")
                                    .font(.custom(customFontBold, size: 20))
                            }
                            .padding(.top)
                            Divider().background(Color.black.opacity(0.4)).padding(.vertical)
                            Text("By clicking 'Place Order'\nyou state acknowledgement and acceptance of ")
                                .font(.custom(customFont, size: 16))
                            + Text("Playground AR")
                                .font(.custom(customFontBold, size: 16))
                                .foregroundColor(PurPle)
                            + Text("'s Return and Refund policy for this transaction.")
                                .font(.custom(customFont, size: 16))
                            
                            Divider()
                                .background(Color.black.opacity(0.4)).padding(.top)
                            
                            
                        }}.padding()
                }
                
                HStack(spacing:0){
                    // Button Checkout to payment
                    VStack{
                        let totalPrice = calculateTotalPrice(for: products) + 15
                        let formattedTotalPrice = formatTotalPrice(totalPrice)
                        Text("Total Payment")
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,alignment: .trailing)
                            .font(.custom(customFontBold, size: 18))
                        Text("฿ \(formattedTotalPrice)")
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,alignment: .trailing)
                            .font(.custom(customFontBold, size: 22))
                    }
                    Spacer()
                    Button {
                        if !showingPopup {
                                showingPopup = true
                            }
                    } label: {
                        
                        Text("Place Order")
                            .font(.custom(customFont, size: 18).bold())
                            .foregroundColor(.white)
                            .padding(.vertical,18)
                            .frame(maxWidth: 150)
                            .background(Color(PurPle))
                            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
                    }
                }
            }
        }.onAppear {
                loginData.fetchUserProfile()
            }
        
        
        
        .popup(isPresented: $showingPopup) {
            
            VStack(spacing:0){
            Image("ThaiQR")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .scaledToFit()
                    .frame(maxWidth:.infinity)
                    .padding(.bottom)
            Image("prompt-pay-logo")
                    .resizable()
                    .frame(maxWidth:.infinity)
                    .scaledToFit()
                    .frame(width: 200)
            Image("prompt-pay-qr")
                    .resizable()
                    .frame(width: 200,height: 200)
                    .scaledToFit()
                
            Text("#93847-39485")
                    .font(.custom(customFont, size: 16))
            Text("Test1")
                    .font(.custom(customFontBold, size: 18))
                let totalPrice = calculateTotalPrice(for: products) + 15
                let formattedTotalPrice = formatTotalPrice(totalPrice)
            Text("฿ \(formattedTotalPrice)")
                    .font(.custom(customFontBold, size: 30))
                    .padding(5)
                Button {
                    showAlert = true
                } label: {
                    Text("Order Paid (฿ \(formattedTotalPrice))")
                        .lineLimit(1)
                        .font(.custom(customFont, size: 18).bold())
                        .foregroundColor(.white)
                        .frame(maxWidth: 300)
                        .padding(.vertical)
                        .background(Color(PurPle))
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
                }
                .padding()
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Verify successful payment"),
                        message: Text("OK"),
                        dismissButton: .default(Text("OK")) {
                            showAlert = false
                            withAnimation {
                                showAlert = false
                                sharedData.cartProducts.removeAll()
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    )
                }
            }
            .background(.white)
            .padding(.horizontal)
        } customize: {
            $0
                .type(.toast)
                .position(.center)
                .animation(.spring())
                .closeOnTapOutside(true)
                .backgroundColor(.black.opacity(0.5))
        }.background(.white)
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        // Create an empty list of products
        @State var products: [Product] = []

        CheckoutView(products: $products)
    }
}

