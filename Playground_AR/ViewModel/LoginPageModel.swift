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
    
    // Profile Properties
    @Published var userName: String = ""
    @Published var userProfileResponse: UserProfileResponse?
    
    // Log Status
    @AppStorage("log_Status") var log_Status: Bool = false
    
    // Login Call
    func login(completion: @escaping (Result<Void, Error>) -> Void) {
        let url = URL(string: "http://192.168.1.33:3000/auth/login")! // Replace with your backend URL
        
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
    
    
    // Fetch User Profile
    func fetchUserProfile() {
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            // Handle case where there's no token (user not logged in)
            return
        }
        
        let url = URL(string: "http://192.168.1.33:3000/users/profile")! // Use the correct endpoint
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                // Print the response data here
                print("Response: \(String(data: data, encoding: .utf8) ?? "No data")")
                
                do {
                    let decodedResponse = try JSONDecoder().decode(LoginPageModel.UserProfileResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.userName = decodedResponse.username
                        // self.userProfileResponse = decodedResponse
                        // Update other UI components based on the user profile
                    }
                } catch {
                    print("Error decoding user profile response: \(error.localizedDescription)")
                }
            } else if let error = error {
                print("Error fetching user profile: \(error.localizedDescription)")
            }
        }.resume()
    }




    
    struct UserProfileResponse: Decodable {
        let username: String
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
    
    func Register() {
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
