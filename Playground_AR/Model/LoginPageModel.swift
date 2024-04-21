//
//  LoginPageModel.swift
//  Playground_AR
//
//  Created by Settawat Buddhakanchana on 18/11/2566 BE.
//

import SwiftUI
import Foundation

enum NetworkError: Error {
    case noData
}

struct LoginResponse: Decodable {
    let token: String?
    let error: String?
    let info: Info?
    
    struct Info: Decodable {
        let message: String
    }
}

class LoginPageModel: ObservableObject {
    
    // Login Properties..
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var showPassword: Bool = false
    
    // Register Properties
    @Published var registerUser: Bool = false
    @Published var email: String = ""
    @Published var address: String = ""
    @Published var phoneNum: String = ""
    @Published var re_Enter_Password: String = ""
    @Published var showReEnterPassword: Bool = false
    @Published var dateOfBirth = Date()
    
    @Published var registeredUsername: String = ""
    
    // Profile Properties
    @Published var id: String = ""
    @Published var userName: String = ""
    @Published var addressUser: String = ""
    @Published var userProfileResponse: UserProfileResponse?
    @Published var image: Data? = nil
    
    // Log Status
    @AppStorage("log_Status") var log_Status: Bool = false
    
    // Login Call
    func login(completion: @escaping (Result<Void, Error>) -> Void) {
        let url = URL(string: "http://192.168.1.39:3000/auth/login")! // Replace with your backend URL
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters = ["username": username, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.noData))
                }
                return
            }
            // DEBUG
            print("Response: \(String(data: data, encoding: .utf8) ?? "No data")")
            
            do {
                let decodedResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                
                if let errorMessage = decodedResponse.info?.message {
                    // Handle authentication failure cases
                    DispatchQueue.main.async {
                        completion(.failure(LoginError.incorrectCredentials(errorMessage)))
                    }
                } else if let token = decodedResponse.token {
                    // Handle successful login
                    UserDefaults.standard.set(token, forKey: "token")
                    DispatchQueue.main.async {
                        withAnimation {
                            self.log_Status = true
                            print("Login successful")
                        }
                        completion(.success(()))
                    }
                }
            } catch {
                // Handle other types of errors
                print("Login error: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(LoginError.decodingError(error.localizedDescription)))
                }
            }
            
        }.resume()
    }
    
    // Register
    func register(completion: @escaping (Result<Void, Error>) -> Void) {
        let url = URL(string: "http://192.168.1.39:3000/auth/register")! // Replace with your backend URL for registration
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "username": username,
            "password": password,
            "email": email,
            "phoneNum": phoneNum,
            "address": address,
            "dateOfBirth": DateFormatter.yyyyMMdd.string(from: dateOfBirth)
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
                guard let _ = data, error == nil else {
                    DispatchQueue.main.async {
                        completion(.failure(error ?? NetworkError.noData))
                    }
                    return
                }

                DispatchQueue.main.async {
                    completion(.success(()))
                }
            }.resume()
        }
    
    
    func fetchUserProfile() {
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            return
        }

        let url = URL(string: "http://192.168.1.39:3000/users/profile")! // Update with your actual API URL

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("Error fetching user profile: \(error?.localizedDescription ?? "No data")")
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(UserProfileResponse.self, from: data)
                DispatchQueue.main.async {
                    self.id = decodedResponse.id
                    self.userName = decodedResponse.username
                    self.email = decodedResponse.email
                    self.address = decodedResponse.address
                    self.phoneNum = decodedResponse.phoneNum
                    self.dateOfBirth = DateFormatter.yyyyMMdd.date(from: decodedResponse.dateOfBirth) ?? Date()

                    // Handle the image
                    if let imageURLString = decodedResponse.image {
                        // Use the provided image URL string
                        if let imageURL = URL(string: imageURLString) {
                            URLSession.shared.dataTask(with: imageURL) { data, _, error in
                                if let error = error {
                                    print("Error downloading image: \(error.localizedDescription)")
                                } else if let data = data {
                                    DispatchQueue.main.async {
                                        self.image = data // Update the image data
                                    }
                                }
                            }.resume()
                        } else {
                            print("Invalid image URL")
                        }
                    } else {
                        self.image = nil // Set image to nil if there's no image file
                    }
                }
            } catch {
                print("Error decoding user profile response: \(error.localizedDescription)")
            }
        }.resume()
    }


    
    func uploadUserImage(imageData: Data, completion: @escaping (Result<Void, Error>) -> Void) {
            guard let token = UserDefaults.standard.string(forKey: "token") else {
                completion(.failure(LoginError.noData))
                return
            }

            let url = URL(string: "http://192.168.1.39:3000/users/upload")!

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

            let boundary = "Boundary-\(UUID().uuidString)"
            request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

            var body = Data()
            let fieldName = "image"
            let fileName = "profileImage_\(self.id)"

            // Append image data
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
            body.append("--\(boundary)--\r\n".data(using: .utf8)!)

            request.httpBody = body

            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else {
                    completion(.failure(error ?? LoginError.networkError(message: "Failed to connect to server")))
                    return
                }

                do {
                    if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                        // Upload successful
                        completion(.success(()))
                    } else {
                        // Handle API errors
                        let errorResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                        completion(.failure(LoginError.customError(errorResponse.info?.message ?? "Unknown error")))
                    }
                } catch {
                    // Handle decoding error
                    completion(.failure(LoginError.decodingError("Failed to decode server response")))
                }
            }.resume()
        }
    
    
    
    
    
    struct UserProfileResponse: Decodable {
            let id: String
            let username: String
            let email: String
            let address: String
            let phoneNum: String
            let dateOfBirth: String
            let image: String?
        }
    
    struct RegisterResponse: Decodable {
        // Define backend's response structure
    }
    
    struct User: Decodable {
        let username: String
    }
    
    func logout() {
        DispatchQueue.main.async {
            withAnimation {
                self.log_Status = false
            }
        }
    }
    
    struct LoginResponse: Decodable {
        let token: String?
        let error: String?
        let info: Info?
        
        struct Info: Decodable {
            let message: String
        }
    }
}

enum LoginError: Error {
    case networkError(message: String)
    case noData
    case incorrectCredentials(String)
    case customError(String)
    case decodingError(String)
    
    var localizedDescription: String {
        switch self {
        case .networkError(let message):
            return "Network error: \(message)"
        case .noData:
            return "No data received from the server"
        case .incorrectCredentials(let message) where message == "Incorrect username or password":
            return "Incorrect username or password."
        case .incorrectCredentials(let message):
            return "Incorrect username or password.\n\(message)"
        case .customError(let message):
            return "Custom error: \(message)"
        case .decodingError(let message):
            return "Decoding error: \(message)"
        }
    }
}

extension LoginPageModel {
    func errorMessage(for error: Error) -> String {
        if let loginError = error as? LoginError {
            return loginError.localizedDescription
        } else {
            return "An unexpected error occurred."
        }
    }
}

extension DateFormatter {
    static let yyyyMMdd: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}


extension LoginPageModel {
    func updateUserProfile(completion: @escaping (Result<Void, Error>) -> Void) {
        // Create the URL using the user ID
        let url = URL(string: "http://192.168.1.39:3000/users/\(self.id)")!
        var request = URLRequest(url: url)
        
        // Set the request method to PUT for updating the user profile
        request.httpMethod = "PUT"
        
        // Construct the request body with the multipart/form-data format
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        
        // Append user data with the specified boundary and field name
        func appendFormData(name: String, value: String) {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }
        
        // Append user details to the body
        appendFormData(name: "username", value: self.userName)
        appendFormData(name: "email", value: self.email)
        appendFormData(name: "address", value: self.address)
        appendFormData(name: "phoneNum", value: self.phoneNum)
        appendFormData(name: "dateOfBirth", value: DateFormatter.yyyyMMdd.string(from: self.dateOfBirth))
        
        // Append image data if available
        if let imageData = image {
            let fieldName = "image"
            let fileName = "profileImage_\(self.id)"
            
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        // Close the body with the boundary
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body

        // Start the data task
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle response
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(error ?? LoginError.networkError(message: "Failed to connect to server")))
                }
                return
            }

            do {
                if let httpResponse = response as? HTTPURLResponse {
                    let _ = String(data: data, encoding: .utf8)

                    if httpResponse.statusCode == 200 {
                        // Handle success
                        completion(.success(()))
                    } else {
                        // Handle API errors
                        let errorResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                        DispatchQueue.main.async {
                            completion(.failure(LoginError.customError(errorResponse.info?.message ?? "Unknown error")))
                        }
                    }
                } else {
                    // Handle unexpected response types
                    DispatchQueue.main.async {
                        completion(.failure(LoginError.customError("Unexpected response type")))
                    }
                }
            } catch {
                // Handle decoding error
                DispatchQueue.main.async {
                    completion(.failure(LoginError.decodingError("Failed to decode server response")))
                }
            }
        }.resume()
    }
}

