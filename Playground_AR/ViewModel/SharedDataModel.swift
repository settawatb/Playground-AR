//
//  SharedDataModel.swift
//  Playground_AR
//
//  Created by Settawat Buddhakanchana on 25/12/2566 BE.
//

import SwiftUI

class SharedDataModel: ObservableObject {
    
    // Detail Product Data
    @Published var detailProduct: Product?
    @Published var showDetailProduct: Bool = false
    
    // Matched Geometry Effect from Search page
    @Published var fromSearchPage: Bool = false
    
    // Favorite Products
    @Published var favoritedProducts: [Product] = []
    
    // Cart Products
    @Published var cartProducts: [Product] = []
    
    // calculating Total price
    func getTotalPrice() -> String {
        var total: Int = 0

        for product in cartProducts {
            let price = product.price.replacingOccurrences(of: "THB", with: "")
            if let quantity = product.quantity, let priceInt = Int(price) {
                let priceTotal = quantity * priceInt
                total += priceTotal
            }
        }

        // Format the total with separators
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        if let formattedNumber = numberFormatter.string(from: NSNumber(value: total)) {
            return "\(formattedNumber) THB"
        }
        return "\(total) THB"
    }
}

