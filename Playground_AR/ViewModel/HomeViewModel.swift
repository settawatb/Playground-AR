//
//  HomeViewModel.swift
//  Playground_AR
//
//  Created by Settawat Buddhakanchana on 4/12/2566 BE.
//

import SwiftUI
import Combine

class HomeViewModel: ObservableObject {

    @Published var productType: ProductType = .All
    @Published var products: [Product] = []
    @Published var currentPage: Int = 0
    
    let productsPerPage = 6

    //Sample Products
//    @Published var products: [Product] = [
//        Product(type: [.All, .Arttoy], title: "Offline Sample Product", subtitle: "Arttoys", price: "12000", productImage: "product_1_kaws" and other ),
//    ]
    
    var searchCancellable: AnyCancellable?


    // Filtered Products
    @Published var filteredProducts: [Product] = []
    
    //More Products on the type
    @Published var showMoreProductsOnType: Bool = false

    //Search Data...
    @Published var searchText: String = ""
    @Published var searchActivated: Bool = false
    @Published var searchedProducts: [Product]?

    init(){
        fetchProductsFromAPI() // Call the function to fetch data when the view model is initialized
        
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
        
    func fetchProductsFromAPI() {
        guard let url = URL(string: baseURL+"products/") else {
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            do {
                let decoder = JSONDecoder()
                let decodedProducts = try decoder.decode([Product].self, from: data)

                DispatchQueue.main.async {
                    self.products = decodedProducts
                    self.filterProductByType() // Update filteredProducts after fetching data
                }
            } catch let decodingError {
                print("Error decoding JSON: \(decodingError)")
                print("Raw JSON Data: \(String(data: data, encoding: .utf8) ?? "Unable to convert to String")")
            }
        }.resume()
    }



    func filterProductByType() {
        DispatchQueue.global(qos: .userInteractive).async {
            let results = self.products.filter { product in
                product.type.contains(self.productType)
            }

            DispatchQueue.main.async {
                self.filteredProducts = results
                self.currentPage = 0
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
