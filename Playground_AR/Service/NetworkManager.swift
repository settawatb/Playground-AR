//
//  NetworkManager.swift
//  Playground_AR
//
//  Created by Settawat Buddhakanchana on 26/2/2567 BE.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum CustomNetworkError: Error {
    case invalidURL
    case noData
    case authenticationError
}

struct NetworkManager {
    static let shared = NetworkManager()

    private init() {}

    func request(_ endpoint: String, method: HTTPMethod, parameters: [String: Any]?, authToken: String? = nil, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        guard let url = URL(string: "http://192.168.1.39:3000/\(endpoint)") else {
            completion(.failure(CustomNetworkError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        // Add authentication token to the request header if available
        if let authToken = authToken {
            request.addValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        }

        // Add parameters to the request body if needed
        if let parameters = parameters {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(CustomNetworkError.noData))
                return
            }

            // Log the server response as a string for debugging
            if let responseString = String(data: data, encoding: .utf8) {
                print("Server response data: \(responseString)")
            }

            do {
                // Parse JSON response
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    // Check for authentication errors
                    if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode == 401 {
                        completion(.failure(CustomNetworkError.authenticationError))
                    } else {
                        completion(.success(json))
                    }
                } else {
                    completion(.failure(CustomNetworkError.noData))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    func uploadFiles(formData: [String: Any], imageDataArray: [Data], model3DData: Data, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        guard let url = URL(string: "http://192.168.1.39:3000/products/upload") else {
            completion(.failure(CustomNetworkError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()

        // Add form data to the body
        for (key, value) in formData {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }

        // Add image data to the body
        for (index, imageData) in imageDataArray.enumerated() {
            let fieldName = "image\(index)"
            let fileName = "image\(index).png"

            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
        }

        // Add model 3D data to the body
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"usdzFile\"; filename=\"model.usdz\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: application/octet-stream\r\n\r\n".data(using: .utf8)!)
        body.append(model3DData)
        body.append("\r\n".data(using: .utf8)!)

        // End boundary
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body

        // Perform the network request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(CustomNetworkError.noData))
                return
            }

            // Log the server response as a string for debugging
            if let responseString = String(data: data, encoding: .utf8) {
                print("Server response data: \(responseString)")
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    completion(.success(json))
                } else {
                    completion(.failure(CustomNetworkError.noData))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func updateProduct(productID: String, formData: [String: Any], imageDataArray: [Data], model3DData: Data?, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        guard let url = URL(string: "http://192.168.1.39:3000/products/update/\(productID)") else {
            completion(.failure(CustomNetworkError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"

        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()

        // Add form data to the body
        for (key, value) in formData {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }

        // Add image data to the body
        for (index, imageData) in imageDataArray.enumerated() {
            let fieldName = "image\(index)"
            let fileName = "image\(index).png"

            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
        }

        // Add 3D model data to the body if available
        if let model3DData = model3DData {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"usdzFile\"; filename=\"model.usdz\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: application/octet-stream\r\n\r\n".data(using: .utf8)!)
            body.append(model3DData)
            body.append("\r\n".data(using: .utf8)!)
        }

        // End boundary
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(CustomNetworkError.noData))
                return
            }

            // Log the server response for debugging
            if let responseString = String(data: data, encoding: .utf8) {
                print("Server response data: \(responseString)")
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    completion(.success(json))
                } else {
                    completion(.failure(CustomNetworkError.noData))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }


    func fetchData(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(CustomNetworkError.noData))
                return
            }

            completion(.success(data))
        }.resume()
    }
}
