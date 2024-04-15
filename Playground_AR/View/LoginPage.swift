//
//  LoginPage.swift
//  Playground_AR
//
//  Created by Settawat Buddhakanchana on 18/11/2566 BE.
//

import SwiftUI

struct LoginPage: View {
    @StateObject var loginData: LoginPageModel = LoginPageModel()
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var registrationSuccess = false
    
    var body: some View {
        VStack {
            VStack {
                ZStack {
                    Image("Onboard1")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity, maxHeight: 1000)
                        .frame(width: 400, height: 640, alignment: .bottomLeading)
                        .clipped()
                        .opacity(0.3)
                        .ignoresSafeArea()
                    
                    Image("logo")
                        .resizable()
                        .frame(alignment: .topLeading)
                        .aspectRatio(contentMode: .fit)
                        .padding(35)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 5, y: 5)
                }.frame(height: getReact().height / 3.5)
            }
            
            ScrollView(.vertical, showsIndicators: false) {
                // Login Page
                VStack(spacing: 15) {
                    Text(loginData.registerUser ? "Register" :  "Login")
                        .font(.custom(customFont, size: 25).bold())
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Custom Text Field
                    CustomTextField(icon: "envelope", title: "Username", hint: "username01", value: $loginData.username, showPassword: .constant(false))
                        .padding(.top,20)
                    
                    CustomTextField(icon: "lock", title: "Password", hint: "Abc1234", value: $loginData.password, showPassword: $loginData.showPassword)
                        .padding(.top,10)
                    
                    // Register Reenter Password
                    if loginData.registerUser {
                        CustomTextField(icon: "lock", title: "Re-Enter Password", hint: "Abc1234", value: $loginData.re_Enter_Password, showPassword: $loginData.showReEnterPassword)
                            .padding(.top,10)
                        CustomTextField(icon: "phone", title: "Telephone Number", hint: "09XXXXXXXX", value: $loginData.phoneNum, showPassword: .constant(false))
                            .padding(.top,20)
                        CustomTextField(icon: "envelope", title: "Email", hint: "sample@mail.com", value: $loginData.email, showPassword: .constant(false))
                            .padding(.top,20)
                        CustomTextField(icon: "mappin.and.ellipse", title: "Address", hint: "your address", value: $loginData.address, showPassword: .constant(false))
                            .padding(.top,20)
                        DateOfBirthPicker(selectedDate: $loginData.dateOfBirth)
                            .padding(.top,20)
                    }
                    
                    // Login Button
                    Button(action: {
                        if loginData.registerUser {
                            registerUser()
                        } else {
                            loginUser()
                        }
                    }) {
                        Text(loginData.registerUser ? "Create Account" : "Login")
                            .font(.custom(customFont, size: 17))
                            .padding(.vertical, 20)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .background(Color(.black))
                            .cornerRadius(15)
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 5, y: 5)
                    }
                    .padding(.top, 8)
                    .padding(.horizontal)
                    .alert(isPresented: Binding(
                        get: { showAlert },
                        set: { _ in showAlert = false }
                    )) {
                        Alert(title: Text(registrationSuccess ? "Register Successfully" : "Error"),
                              message: Text(alertMessage),
                              dismissButton: .default(Text("OK")) {
                            // Navigate back to the login page if registration was successful
                            if registrationSuccess {
                                withAnimation {
                                    loginData.registerUser.toggle()
                                }
                            }
                        }
                        )
                    }
                    
                    
                    // create an account Button
                    Button(action: {
                        withAnimation {
                            loginData.registerUser.toggle()
                        }
                    }) {
                        Text(loginData.registerUser ? "Back to Login" : "Create Account")
                            .font(.custom(customFont, size: 14))
                            .fontWeight(.semibold)
                            .foregroundColor(Color(red: 125/255, green: 122/255, blue: 255/255))
                    }
                    .padding(.top, 8)
                }
                .padding(30)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Color.white
                    .clipShape(CustomCorners(corners:[.topLeft,.topRight], radius: 25))
                    .ignoresSafeArea()
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 240/255, green: 240/255, blue: 255/255))
        .onChange(of: loginData.registerUser) { _, _ in
            loginData.username = ""
            loginData.password = ""
            loginData.re_Enter_Password = ""
            loginData.email = ""
            loginData.address = ""
            loginData.showPassword = false
            loginData.showReEnterPassword = false
            
            if registrationSuccess {
                loginData.username = loginData.registeredUsername
            }
        }
    }
    
    @ViewBuilder
    func CustomTextField(icon: String, title: String, hint:String, value: Binding<String>, showPassword: Binding<Bool>)->some View {
        VStack(alignment: .leading, spacing: 12) {
            Label {
                Text(title)
                    .font(.custom(customFont, size:14))
            } icon: {
                Image(systemName: icon)
            }
            .foregroundColor(Color.black.opacity(0.8))
            
            if title.contains("Password") && !showPassword.wrappedValue {
                SecureField(hint, text: value)
                    .padding(.top, 2)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
            } else if title.contains("Address") {
                ZStack(alignment: .topLeading) {
                    TextEditor(text: value)
                        .frame(minWidth: 50, maxWidth: .infinity, minHeight: 100, maxHeight: .infinity)
                        .background(Color.gray.opacity(0.1))
                        .padding(.top, 2)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                        .frame(minWidth: 50, maxWidth: .infinity, minHeight: 100, maxHeight: .infinity)
                        .padding(.top, 2)
                        .padding(.bottom, 20)
                }
            } else {
                TextField(hint, text: value)
                    .padding(.top, 2)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
            }
            
            Divider()
                .background(Color.black.opacity(0.4))
        }
        .overlay(
            Group {
                if title.contains("Password") {
                    Button(action: {
                        showPassword.wrappedValue.toggle()
                    }, label: {
                        Text(showPassword.wrappedValue ? "Hide" : "Show")
                            .font(.custom(customFont, size: 13).bold())
                            .foregroundColor(Color(red: 125/255, green: 122/255, blue: 255/255))
                    })
                    .offset(y: 8)
                }
            },
            alignment: .trailing
        )
    }
    
    func loginUser() {
        guard validateLogin() else {
            // Handle validation failure
            return
        }
        
        loginData.login { result in
            switch result {
            case .success:
                print("Login successful")
            case .failure(let error):
                // Handle login failure
                print("Login failed: \(error)")
                alertMessage = loginData.errorMessage(for: error)
                showAlert = true
            }
        }
    }
    
    func registerUser() {
        // Validate registration fields
        guard validateRegistration() else {
            // Validation failed, showAlert is already set in validateRegistration
            return
        }
        
        // Proceed with registration
        loginData.register { result in
            switch result {
            case .success:
                // Set the alert properties only when registration is successful
                alertMessage = "Register Successfully"
                registrationSuccess = true
                
                // Store the registered username
                loginData.registeredUsername = loginData.username
                
                showAlert = true
            case .failure(let error):
                // Handle registration failure
                print("Registration failed: \(error)")
                alertMessage = loginData.errorMessage(for: error)
                showAlert = true
                
                // Reset the alert properties on registration failure
                registrationSuccess = false
            }
        }
    }
    
    
    
    func validateLogin() -> Bool {
        // Implement validation logic for login
        return true
    }
    
    func validateRegistration() -> Bool {
        if loginData.username.isEmpty {
            alertMessage = "Please enter a username."
        } else if loginData.password.isEmpty {
            alertMessage = "Please enter a password."
        } else if loginData.password != loginData.re_Enter_Password {
            alertMessage = "Passwords do not match."
        } else if loginData.phoneNum.isEmpty {
            alertMessage = "Please enter a phone number."
        } else if loginData.email.isEmpty {
            alertMessage = "Please enter an email address."
        } else if loginData.address.isEmpty {
            alertMessage = "Please enter an address."
        } else {
            // Additional validation logic if needed
            return true
        }
        
        // Show an alert for validation failure
        showAlert = true
        return false
    }
}

struct DateOfBirthPicker: View {
    @Binding var selectedDate: Date
    
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            Label {
                Text("Date of Birth")
                    .font(.custom(customFont, size:14))
            } icon: {
                Image(systemName: "calendar")
            }
            DatePicker("Date of Birth", selection: $selectedDate, displayedComponents: [.date])
                .datePickerStyle(CompactDatePickerStyle())
                .labelsHidden()
                .padding(.bottom, 20)
            Divider()
                .background(Color.black.opacity(0.4))
        }
    }
}

#Preview {
    LoginPage()
}
