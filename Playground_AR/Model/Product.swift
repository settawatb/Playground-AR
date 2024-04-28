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
    var productImages: [String] // Changed to array of strings
    var productModel: URL
    var quantity: Int?
    var updateAt: Date
    
    // Coding keys if your property names differ from the JSON keys
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case type = "product_category"
        case title = "product_name"
        case description = "product_desc"
        case price = "product_price"
        case productImages = "product_images" // Changed the key to match the JSON key
        case quantity = "product_quantity"
        case updateAt = "update_at"
        case productModel = "product_model3D"
    }
    
    // Remove the custom date decoding strategy
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode([ProductType].self, forKey: .type)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        
        // Decode price as Int and then convert it to String
        let priceInt = try container.decode(Int.self, forKey: .price)
        price = String(priceInt)
        
        // Decode productImages as an array of strings
        productImages = try container.decode([String].self, forKey: .productImages)
        
        productModel = try container.decode(URL.self, forKey: .productModel)
        quantity = try container.decodeIfPresent(Int.self, forKey: .quantity)
        
        // Use a single date decoding strategy for both formats
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        let updateAtString = try container.decode(String.self, forKey: .updateAt)
        
        if let date = formatter.date(from: updateAtString) {
            updateAt = date
        } else {
            throw DecodingError.dataCorruptedError(
                forKey: .updateAt,
                in: container,
                debugDescription: "Expected date string in ISO8601 format, but found \(updateAtString) instead."
            )
        }
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

