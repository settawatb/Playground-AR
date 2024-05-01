//
//  MyProductViewModel.swift
//  Playground_AR
//
//  Created by Settawat Buddhakanchana on 29/4/2567 BE.
//

import Foundation

class MyProductViewModel: ObservableObject {
    @Published var products: [ProductBySeller] = []
    @Published var isLoading: Bool = true
    @Published var errorMessage: String?

    func fetchSellerProducts(for sellerId: String) {
        print("sellerId: \(sellerId)")

        guard let url = URL(string: baseURL+"products/bySellerId/\(sellerId)") else {
            errorMessage = "Invalid URL"
            return
        }

        print("Request URL: \(url)")

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
            }

            // Handle potential errors in the request
            if let error = error {
                print("Request error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.errorMessage = "Request error: \(error.localizedDescription)"
                }
                return
            }

            // Check if data was received
            guard let data = data else {
                print("No data received from backend")
                DispatchQueue.main.async {
                    self.errorMessage = "No data received from backend"
                }
                return
            }

            print("Response data (raw): \(String(data: data, encoding: .utf8) ?? "No data")")

            // Check the HTTP status code
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
                if httpResponse.statusCode == 404 {
                    // If HTTP status code is 404, handle "No products found" case
                    do {
                        let errorResponse = try JSONDecoder().decode([String: String].self, from: data)
                        if let message = errorResponse["message"], message.contains("No products found") {
                            DispatchQueue.main.async {
                                self.errorMessage = "The product you are selling was not found."
                            }
                            return
                        }
                    } catch {
                        print("Error decoding error response: \(error)")
                    }
                }
            }

            do {
                // Decode the received JSON data into the ProductBySeller model
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let products = try decoder.decode([ProductBySeller].self, from: data)
                print("Decoded products: \(products)")
                DispatchQueue.main.async {
                    self.products = products
                }
            } catch {
                print("Error decoding JSON: \(error)")
                DispatchQueue.main.async {
                    self.errorMessage = "Error decoding JSON: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
}

