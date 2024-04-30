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
                        .font(.custom(customFontBold, size: 40))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .offset(x: 20)
                    
                    Spacer()
                    
                    VStack(spacing: 25) {
                        if let imageData = loginData.image {
                                                    Image(uiImage: UIImage(data: imageData) ?? UIImage())
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                        .frame(width: 130, height: 130)
                                                        .clipShape(Circle())
                                                        .offset(y: -60)
                                                        .padding(.bottom, -80)
                                                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
                                                } else {
                                                    // Placeholder image
                                                    Image("user_placeholder")
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                        .frame(width: 130, height: 130)
                                                        .clipShape(Circle())
                                                        .offset(y: -60)
                                                        .padding(.bottom, -80)
                                                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
                                                }
                        
                        Text(loginData.userName)
                            .font(.custom(customFont, size: 25))
                            .fontWeight(.semibold)
                        
                        HStack {
                            Image(systemName: "location.north.circle.fill")
                                .foregroundColor(.gray)
                                .rotationEffect(.init(degrees: 180))
                            
                            Text(loginData.address)
                                .font(.custom(customFont, size: 15))
                            
//                            Text("Example \nAddress \nBangkok, Thailand")
//                                .font(.custom(customFont, size: 15))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                    }
                    .padding([.horizontal, .bottom])
                    .background(
                        Color.white
                            .cornerRadius(12)
                    )
                    .shadow(color: Color.black.opacity(0.01), radius: 5, x: 5, y: 5)
                    .padding()
                    .padding(.top, 40)
                    .onAppear {
                        loginData.fetchUserProfile()
                    }
                    
                    // Custom Navigation Link
                    
                    CustomNavigationLink(title: "Add Product") {
                        ScrollView {
                            AddProductView()
                                .navigationTitle("Add Product")
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(Color.white.ignoresSafeArea())
                        }
                    }
                    
                    CustomNavigationLink(title: "Edit Profile") {
                        ScrollView {
                            EditProfileView()
                                .navigationTitle("Edit Profile")
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(LightGray.ignoresSafeArea())
                        }
                    }
                    
                    CustomNavigationLink(title: "Order History") {
                            OrderHistoryView()
                                .navigationTitle("Order History")
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(LightGray.ignoresSafeArea())
                    }
                    
                    CustomNavigationLink(title: "My Products") {
                        MyProductView()
                            .navigationTitle("My Products")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(LightGray.ignoresSafeArea())
                    }


                    
                    
                    Button {
                        loginData.logout()
                        // Dismiss current view and navigate back to the root view (login page)
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Logout")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .font(.custom(customFontBold, size: 20))
                            .padding(.horizontal, 135)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.red)
                            .cornerRadius(12)
                    }
                    .padding(16)
                    .padding(.top, 20)
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 5, y: 5)
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
                    .foregroundColor(title == "Add Product" ? .white : .black)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(title == "Add Product" ? .white : .black)
            }
            .padding()
            .background(
                title == "Add Product" ? PurPle.cornerRadius(12) :
                    Color.white.cornerRadius(12)
            )
            .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/.opacity(0.06), width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.02), radius: 5, x: 5, y: 5)
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
