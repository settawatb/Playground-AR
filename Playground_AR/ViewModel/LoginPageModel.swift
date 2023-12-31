//
//  LoginPageModel.swift
//  Playground_AR
//
//  Created by Settawat Buddhakanchana on 18/11/2566 BE.
//

import SwiftUI

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
    
    //Log Status
    @AppStorage("log_Status") var log_Status: Bool = false
    
    // Login Call
    func Login(){
        withAnimation{
            log_Status = true
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

