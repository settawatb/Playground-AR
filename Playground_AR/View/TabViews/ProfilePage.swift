//
//  ProfilePage.swift
//  Playground_AR
//
//  Created by Settawat Buddhakanchana on 17/02/2567 BE.
//

import SwiftUI

struct ProfilePage: View {
    @StateObject var loginData: LoginPageModel = LoginPageModel()
    @Environment(\.presentationMode) var presentationMode
    @State private var isActive: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    Text("My Profile")
                        .font(.custom(customFont, size: 28).bold())
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .offset(x: 20)
                    
                    Spacer()
                    
                    VStack(spacing: 25) {
                        Image("user_placeholder")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .offset(y: -30)
                            .padding(.bottom, -30)
                        
                        Text(loginData.userName)
                            .font(.custom(customFont, size: 25))
                            .fontWeight(.semibold)
                        
                        HStack {
                            Image(systemName: "location.north.circle.fill")
                                .foregroundColor(.gray)
                                .rotationEffect(.init(degrees: 180))
                            
                            Text("Example \nAddress \nBangkok, Thailand")
                                .font(.custom(customFont, size: 15))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                    }
                    .padding([.horizontal, .bottom])
                    .background(
                        Color.white
                            .cornerRadius(12)
                    )
                    .padding()
                    .padding(.top, 40)
                    .onAppear {
                        loginData.fetchUserProfile()
                    }
                    
                    // Custom Navigation Link
                    
                    CustomNavigationLink(title: "Edit Profile") {
                        Text("Edit Profile Content")
                            .navigationTitle("Edit Profile")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(LightGray.ignoresSafeArea())
                    }
                    
                    CustomNavigationLink(title: "Shopping Address") {
                        Text("Shopping Address Content")
                            .navigationTitle("Shopping Address")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(LightGray.ignoresSafeArea())
                    }
                    
                    CustomNavigationLink(title: "Order History") {
                        Text("Order History Content")
                            .navigationTitle("Order History")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(LightGray.ignoresSafeArea())
                    }
                    
                    
                    Button {
                        loginData.logout()
                        // Dismiss current view and navigate back to the root view (login page)
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Logout")
                            .font(.custom(customFont, size: 17))
                            .padding(.horizontal, 135)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.red)
                            .cornerRadius(12)
                    }
                    .padding(.top, 10)
                    .offset(y: 140)
                }
            }
            .navigationBarHidden(true)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LightGray.ignoresSafeArea()
            )
        }
    }
    
    
    @ViewBuilder
    func CustomNavigationLink<Detail: View>(title: String, @ViewBuilder content: @escaping () -> Detail) -> some View {
        NavigationLink {
            content()
        } label: {
            HStack {
                Text(title)
                    .font(.custom(customFont, size: 17))
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.black)
            }
            .padding()
            .background(
                Color.white.cornerRadius(12)
            )
            .padding(.horizontal)
            .padding(.top, 10)
        }
    }
}

struct ProfilePage_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePage()
    }
}
