//
//  Product.swift
//  Playground_AR
//
//  Created by Settawat Buddhakanchana on 4/12/2566 BE.
//

import SwiftUI

// Product Model
struct Product: Identifiable, Hashable, Decodable {
    var id: String
    var type: [ProductType]
    var title: String
    var description: String
    var price: String
    var productImages: [String]
    var productModel: URL
    var quantity: Int?
    var updateAt: Date
    var productSeller: ProductSeller

    // Nested struct for the product seller
    struct ProductSeller: Decodable, Hashable {
        var sellerId: String
        var sellerName: String
        var sellerAddress: String

        // Coding keys for ProductSeller if property names differ from JSON keys
        enum CodingKeys: String, CodingKey {
            case sellerId = "seller_id"
            case sellerName = "seller_name"
            case sellerAddress = "seller_address"
        }
    }

    // Coding keys for Product
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case type = "product_category"
        case title = "product_name"
        case description = "product_desc"
        case price = "product_price"
        case productImages = "product_images"
        case productModel = "product_model3D"
        case quantity = "product_quantity"
        case updateAt = "update_at"
        case productSeller = "product_seller"
    }

    // Decodable initializer
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode properties of Product
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode([ProductType].self, forKey: .type)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        
        // Decode the nested ProductSeller struct
        productSeller = try container.decode(ProductSeller.self, forKey: .productSeller)
        
        // Decode price as Int and convert to String
        let priceInt = try container.decode(Int.self, forKey: .price)
        price = String(priceInt)
        
        // Decode productImages as an array of strings
        productImages = try container.decode([String].self, forKey: .productImages)
        
        // Decode product model URL
        productModel = try container.decode(URL.self, forKey: .productModel)
        
        // Decode quantity (if present)
        quantity = try container.decodeIfPresent(Int.self, forKey: .quantity)
        
        // Decode date using the date formatter
        let updateAtString = try container.decode(String.self, forKey: .updateAt)
        let dateFormatter = ISO8601DateFormatter()
        updateAt = dateFormatter.date(from: updateAtString) ?? Date()
    }

    // Conform to Equatable
    static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id &&
               lhs.type == rhs.type &&
               lhs.title == rhs.title &&
               lhs.description == rhs.description &&
               lhs.price == rhs.price &&
               lhs.productImages == rhs.productImages &&
               lhs.productModel == rhs.productModel &&
               lhs.quantity == rhs.quantity &&
               lhs.updateAt == rhs.updateAt &&
               lhs.productSeller == rhs.productSeller
    }

    // Conform to Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(type)
        hasher.combine(title)
        hasher.combine(description)
        hasher.combine(price)
        hasher.combine(productImages)
        hasher.combine(productModel)
        hasher.combine(quantity)
        hasher.combine(updateAt)
        hasher.combine(productSeller)
    }
}



// Product Types
enum ProductType: String, CaseIterable, Decodable {
    case All = "All"
    case Arttoy = "Arttoy"
    case Doll = "Doll"
    case Figure = "Figure"
    case Game = "Game"

    init(from decoder: Decoder) throws {
        let rawValue = try decoder.singleValueContainer().decode(String.self)
        if let type = ProductType(rawValue: rawValue) {
            self = type
        } else if rawValue.hasPrefix(".") {
            // Handle other cases with a dot prefix
            self = .All
        } else if rawValue.lowercased() == "arttoy" {
            self = .Arttoy
        } else if rawValue.lowercased() == "doll" {
            self = .Doll
        } else if rawValue.lowercased() == "figure" {
            self = .Figure
        } else if rawValue.lowercased() == "game" {
            self = .Game
        } else {
            throw DecodingError.dataCorruptedError(
                in: try decoder.singleValueContainer(),
                debugDescription: "Invalid ProductType raw value: \(rawValue)"
            )
        }
    }
}

struct Seller: Decodable {
    var sellerId: String
    var sellerName: String
    var sellerAddress: String

    enum CodingKeys: String, CodingKey {
        case sellerId = "seller_id"
        case sellerName = "seller_name"
        case sellerAddress = "seller_address"
    }
}


//extension DateFormatter {
//    static var iso8601Full: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//        formatter.calendar = Calendar(identifier: .iso8601)
//        formatter.timeZone = TimeZone(secondsFromGMT: 0)
//        formatter.locale = Locale(identifier: "en_US_POSIX")
//        return formatter
//    }()
//}

extension DateFormatter {
    static var dayMonthYear: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = TimeZone(identifier: "Asia/Bangkok")
        formatter.locale = Locale(identifier: "th_TH")
        return formatter
    }()
}


// for product seller

struct ProductBySeller: Identifiable, Decodable {
    var id: String
    var type: [String]
    var title: String
    var description: String
    var price: Double
    var productImages: [String]
    var productModel3D: URL
    var productModel3DFilename: String
    var quantity: Int
    var updateAt: Date

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case type = "product_category"
        case title = "product_name"
        case description = "product_desc"
        case price = "product_price"
        case productImages = "product_images"
        case productModel3D = "product_model3D"
        case quantity = "product_quantity"
        case updateAt = "update_at"
    }

    // Initialize the model
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode([String].self, forKey: .type)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        price = try container.decode(Double.self, forKey: .price)
        productImages = try container.decode([String].self, forKey: .productImages)
        productModel3D = try container.decode(URL.self, forKey: .productModel3D)
        productModel3DFilename = productModel3D.lastPathComponent
        quantity = try container.decode(Int.self, forKey: .quantity)

        let dateString = try container.decode(String.self, forKey: .updateAt)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = dateFormatter.date(from: dateString) {
            updateAt = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .updateAt, in: container, debugDescription: "Invalid date format")
        }
    }
}


extension ProductBySeller {
    func extractModel3DFilename() -> String {
        return productModel3D.lastPathComponent
    }
}
