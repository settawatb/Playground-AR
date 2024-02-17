//
//  LoginPageModel.swift
//  Playground_AR
//
//  Created by Settawat Buddhakanchana on 18/11/2566 BE.
//

import SwiftUI

enum NetworkError: Error {
    case noData
}

class LoginPageModel: ObservableObject {
    
    // Login Properties..
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var showPassword: Bool = false
    
    // Register Properties
    @Published var registerUser : Bool = false
    @Published var phoneNum : String = ""
    @Published var re_Enter_Password: String = ""
    @Published var showReEnterPassword: Bool = false
    
    // Profile Properties
    @Published var userEmail: String = ""
    
    // Log Status
    @AppStorage("log_Status") var log_Status: Bool = false
    
    // Login Call
    func login(completion: @escaping (Result<Void, Error>) -> Void) {
        let url = URL(string: "http://192.168.1.39:3000/auth/login")! // Replace with your backend URL

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let parameters = ["email": email, "password": password]
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

            do {
                let decodedResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                DispatchQueue.main.async {
                    // Handle successful login, e.g., save the token to UserDefaults
                    UserDefaults.standard.set(decodedResponse.token, forKey: "token")
                    self.log_Status = true
                    completion(.success(()))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
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

            let url = URL(string: "http://192.168.1.39:3000/users/profile")! // Use the correct endpoint

            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    do {
                        let decodedResponse = try JSONDecoder().decode(UserProfileResponse.self, from: data)
                        DispatchQueue.main.async {
                            self.userEmail = decodedResponse.user.email
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
        let user: User
        // Add other properties if needed
    }

    struct User: Decodable {
        let email: String
        // Add other properties if needed
    }
    
    func logout() {
            withAnimation {
                log_Status = false
            }
        }


    func Register(){
        withAnimation{
            log_Status = true
        }
    }
    
    func ForgotPassword(){
        // Action ForgotPassword
    }
}

struct LoginResponse: Decodable {
    let token: String
    // Add other properties if needed
}
