//
//  HomeViewModel.swift
//  Playground_AR
//
//  Created by Settawat Buddhakanchana on 4/12/2566 BE.
//

import SwiftUI
//Using Combine to monitor search field
import Combine

class HomeViewModel: ObservableObject {

    @Published var productType: ProductType = .All

    //Sample Products
    @Published var products: [Product] = [
        Product(type: [.All, .Arttoy], title: "KAWS X PEANUTS JOE KAWS", subtitle: "Arttoys", price: "12000", productImage: "product_1_kaws"),
        Product(type: [.All, .Arttoy], title: "KAWS MONO FLAYED COMPANION", subtitle: "Arttoys", price: "23599", productImage: "product_2_kaws_mono"),
        Product(type: [.All, .Doll], title: "TEDDY HOUSE MARTIE", subtitle: "Doll", price: "650", productImage: "product_3_martie_doll"),
        Product(type: [.All, .Arttoy], title: "POLYGO LITTLE GREEN MAN", subtitle: "Arttoys", price: "760", productImage: "product_4_green_man")
    ]


    // Filtered Products
    @Published var filteredProducts: [Product] = []
    
    //More Products on the type
    @Published var showMoreProductsOnType: Bool = false

    //Search Data...
    @Published var searchText: String = ""
    @Published var searchActivated: Bool = false
    @Published var searchedProducts: [Product]?
    
    var searchCancellable: AnyCancellable?

    init(){
        filterProductByType()
        
        searchCancellable = $searchText.removeDuplicates()
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink(receiveValue: { str in
                if str != ""{
                    self.filterProductBySearch()
                }
                else{
                    self.searchedProducts = nil
                }
            })
    }

    func filterProductByType(){
        // Filtering Product By Product Type
        DispatchQueue.global(qos: .userInteractive).async {
            let results = self.products
                .lazy
                .filter { product in
                    return product.type.contains(self.productType)
                }
                .prefix(4)
            DispatchQueue.main.async {
                self.filteredProducts = results.compactMap { product in
                    return product
                }
            }
        }
    }

    func filterProductBySearch() {
        
        // Filtering Product By Product Type
        DispatchQueue.global(qos: .userInteractive).async {
            let results = self.products
                .lazy
                .filter { product in
                    
                    return product.title.lowercased().contains(self.searchText.lowercased())
                }
            DispatchQueue.main.async {
                self.searchedProducts = results.compactMap({ product in
                    return product
                })
            }
        }
    }
}
