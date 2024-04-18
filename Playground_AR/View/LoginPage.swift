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
            // Logo and background images
            VStack {
                ZStack {
                    Image("Onboard1")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 400, height: 640, alignment: .bottomLeading)
                        .opacity(0.3)
                        .ignoresSafeArea()
                    
                    Image("logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(35)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 5, y: 5)
                }
                .onTapGesture {
                    hideKeyboard()
                }
                .frame(height: getReact().height / 3.5)
            }
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 15) {
                    // Register or login label
                    Text(loginData.registerUser ? "Register" : "Login")
                        .font(.custom(customFont, size: 25).bold())
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Custom Text Fields for login
                    CustomTextField(icon: "envelope", title: "Username", hint: "username01", value: $loginData.username, showPassword: .constant(false))
                        .padding(.top, 20)
                    
                    CustomTextField(icon: "lock", title: "Password", hint: "Abc1234", value: $loginData.password, showPassword: $loginData.showPassword)
                        .padding(.top, 10)
                    
                    if loginData.registerUser {
                        // Register-related fields
                        CustomTextField(icon: "lock", title: "Re-Enter Password", hint: "Abc1234", value: $loginData.re_Enter_Password, showPassword: $loginData.showReEnterPassword)
                            .padding(.top, 10)
                        
                        CustomTextField(icon: "phone", title: "Telephone Number", hint: "09XXXXXXXX", value: $loginData.phoneNum, showPassword: .constant(false))
                            .padding(.top, 20)
                        
                        CustomTextField(icon: "envelope", title: "Email", hint: "sample@mail.com", value: $loginData.email, showPassword: .constant(false))
                            .padding(.top, 20)
                        
                        CustomTextField(icon: "mappin.and.ellipse", title: "Address", hint: "your address", value: $loginData.address, showPassword: .constant(false))
                            .padding(.top, 20)

                        DateOfBirthPicker(selectedDate: $loginData.dateOfBirth)
                            .padding(.top, 20)
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
                            .font(.custom(customFontBold, size: 17))
                            .padding(.vertical, 20)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .background(Color.black)
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
                                if registrationSuccess {
                                    withAnimation {
                                        loginData.registerUser.toggle()
                                    }
                                }
                            })
                    }
                    
                    // Create an account button
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
            .background(Color.white.clipShape(CustomCorners(corners: [.topLeft, .topRight], radius: 25)).ignoresSafeArea())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
        .onChange(of: loginData.registerUser) { _, _ in
            resetRegistrationFields()
        }
    }
    
    // Function to reset registration fields when switching between login and register modes
    func resetRegistrationFields() {
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

    // Implement login and registration functions
    func loginUser() {
        guard validateLogin() else {
            return
        }
        loginData.login { result in
            switch result {
                case .success:
                    print("Login successful")
                case .failure(let error):
                    print("Login failed: \(error)")
                    alertMessage = loginData.errorMessage(for: error)
                    showAlert = true
            }
        }
    }

    func registerUser() {
        guard validateRegistration() else {
            return
        }
        loginData.register { result in
            switch result {
                case .success:
                    alertMessage = "Register Successfully"
                    registrationSuccess = true
                    loginData.registeredUsername = loginData.username
                    showAlert = true
                case .failure(let error):
                    print("Registration failed: \(error)")
                    alertMessage = loginData.errorMessage(for: error)
                    showAlert = true
                    registrationSuccess = false
            }
        }
    }

    // Validation functions
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
            return true
        }
        showAlert = true
        return false
    }
}

// Define DateOfBirthPicker
struct DateOfBirthPicker: View {
    @Binding var selectedDate: Date
    
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            Label {
                Text("Date of Birth")
                    .font(.custom(customFontBold, size:14))
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

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

@ViewBuilder
func CustomTextField(icon: String, title: String, hint: String, value: Binding<String>, showPassword: Binding<Bool>) -> some View {
    VStack(alignment: .leading, spacing: 12) {
        // Label for the title with icon
        Label {
            Text(title)
                .font(.custom(customFontBold, size: 14))
        } icon: {
            Image(systemName: icon)
        }
        .foregroundColor(Color.black.opacity(0.8))

        // Determine the appropriate input view based on the title
        if title.contains("Password") && !showPassword.wrappedValue {
            // SecureField for password
            SecureField(hint, text: value)
                .padding(.top, 2)
                .disableAutocorrection(true)
                .autocapitalization(.none)
        } else if title.contains("Address") {
            // TextEditor for address input
            ZStack(alignment: .topLeading) {
                TextEditor(text: value)
                    .frame(minWidth: 50, maxWidth: .infinity, minHeight: 100, maxHeight: 100)
                    .background(Color.gray.opacity(0.1))
                    .padding(.top, 2)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                
                // Outlined view for the text editor
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 1)
                    .frame(minWidth: 50, maxWidth: .infinity, minHeight: 100, maxHeight: 100)
                    .padding(.top, 2)
                    .padding(.bottom, 20)
            }
        } else if title.contains("Telephone Number") {
            // TextField for telephone number with limited length
            TextField(hint, text: value)
                .padding(.top, 2)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .keyboardType(.numberPad) // Limit keyboard to number pad
                .onChange(of: value.wrappedValue) { newValue, oldValue in
                    // Filter non-numeric characters and limit length to 10 characters
                    let filteredValue = newValue.filter { $0.isNumber }
                    if filteredValue.count > 10 {
                        value.wrappedValue = String(filteredValue.prefix(10))
                    } else {
                        value.wrappedValue = filteredValue
                    }
                }
        } else {
            // Default TextField for other types of input
            TextField(hint, text: value)
                .padding(.top, 2)
                .disableAutocorrection(true)
                .autocapitalization(.none)
        }
        
        // Divider at the bottom
        Divider()
            .background(Color.black.opacity(0.4))
    }
    // Overlay for password visibility toggle button (if applicable)
    .overlay(
        Group {
            if title.contains("Password") {
                Button(action: {
                    showPassword.wrappedValue.toggle()
                }) {
                    Text(showPassword.wrappedValue ? "Hide" : "Show")
                        .font(.custom(customFont, size: 13).bold())
                        .foregroundColor(Color(red: 125/255, green: 122/255, blue: 255/255))
                }
                .offset(y: 8)
            }
        },
        alignment: .trailing
    )
}


#Preview {
    LoginPage()
}
