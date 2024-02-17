//
//  LoginPage.swift
//  Playground_AR
//
//  Created by Settawat Buddhakanchana on 18/11/2566 BE.
//

import SwiftUI

struct LoginPage: View {
    @StateObject var loginData: LoginPageModel = LoginPageModel()
    var body: some View {
        VStack{
            
            VStack{
            
                
                ZStack{
                    
                    Image("Onboard1")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity,maxHeight: 1000)
                        .frame(width: 400, height:640, alignment: .bottomLeading)
                        .clipped()
                        .opacity(0.3)
                        .ignoresSafeArea()
                    
                    Image("logo")
                        .resizable()
                        .frame(alignment: .topLeading)
                        .aspectRatio(contentMode: .fit)
                        .padding(35)
                        .shadow(color:Color.black.opacity(0.1),radius: 5, x: 5, y: 5)
                    
                }.frame(height: getReact().height / 3.5)
            }
            
            
            ScrollView(.vertical, showsIndicators: false){
                
                // Login Page
                VStack(spacing: 15){
                    Text(loginData.registerUser ? "Register" :  "Login")
                        .font(.custom(customFont, size: 25).bold())
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                    
                // Custom Text Field
                    
                    CustomTextField(icon: "envelope", title: "Email", hint: "Example@gmail.com", value: $loginData.email, showPassword:.constant(false))
                        .padding(.top,20)
                    
                    CustomTextField(icon: "lock", title: "Password", hint: "Abc1234", value: $loginData.password, showPassword:$loginData.showPassword)
                        .padding(.top,10)
                    
                // Register Reenter Password
                    if loginData.registerUser{
                        CustomTextField(icon: "lock", title: "Re-Enter Password", hint: "Abc1234", value: $loginData.re_Enter_Password, showPassword: $loginData.showReEnterPassword)
                            .padding(.top,10)
                        CustomTextField(icon: "phone", title: "Telephone Number", hint: "09XXXXXXXX", value: $loginData.phoneNum, showPassword:.constant(false))
                            .padding(.top,20)
                        
                    }
                    
                    // Forgot Password Button
//                    Button {
//                        loginData.ForgotPassword()
//                    } label: {
//                        
//                        Text("Forgot Password ?")
//                            .font(.custom(customFont, size: 14))
//                            .fontWeight(.semibold)
//                            .foregroundColor(Color(red: 125/255, green: 122/255, blue: 255/255))
//                    }
//                    .padding(.top, 8)
//                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Login Button
                    Button {
                        if loginData.registerUser {
                            loginData.Register()
                        } else {
                            loginData.login { result in
                                switch result {
                                case .success:
                                    // Handle successful login, e.g., navigate to the next screen
                                    print("Login successful")
                                case .failure(let error):
                                    // Handle login failure
                                    print("Login failed: \(error)")
                                }
                            }
                        }
                    } label: {
                        Text("Login")
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

                    
                    // Register Button
                    Button {
                        withAnimation{
                            loginData.registerUser.toggle()
                        }
                    } label: {
                        
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
                // Custom Corners
                    .clipShape(CustomCorners(corners:[.topLeft,.topRight], radius: 25))
                    .ignoresSafeArea()
            )
            
        }
        
        // Background
        
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 240/255, green: 240/255, blue: 255/255))
        
        // Clearing data when change
        .onChange(of: loginData.registerUser) { _, _ in
            loginData.email = ""
            loginData.password = ""
            loginData.re_Enter_Password = ""
            loginData.showPassword = false
            loginData.showReEnterPassword = false
        }
    }
    
    @ViewBuilder
    func CustomTextField(icon: String, title: String, hint:String, value: Binding<String>,showPassword:Binding<Bool>)->some View{
        
        VStack(alignment: .leading, spacing: 12) {
            
            Label {
                Text(title)
                    .font(.custom(customFont, size:14))
            } icon: {
                Image(systemName: icon)
            }
            .foregroundColor(Color.black.opacity(0.8))
            
            if title.contains("Password") && !showPassword.wrappedValue{
                SecureField(hint, text: value)
                    .padding(.top,2)
            }
            else{
                TextField(hint, text: value)
                    .padding(.top,2)
            }
            
            Divider()
                .background(Color.black.opacity(0.4))
            
        }
        
        // Show Password Field
        .overlay(
            
            Group{
                if title.contains("Password"){
                    Button(action: {
                        showPassword.wrappedValue.toggle()
                    }, label: {
                        Text(showPassword.wrappedValue ? "Hide" : "Show")
                            .font(.custom(customFont, size: 13).bold())
                            .foregroundColor(PurPle)
                    })
                    .offset(y: 8)
                }
            }
            
            ,alignment: .trailing
        
        )
        
        
    }
}

#Preview {
    LoginPage()
}
