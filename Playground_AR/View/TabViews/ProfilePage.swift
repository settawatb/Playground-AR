//
//  ProfilePage.swift
//  Playground_AR
//
//  Created by Settawat Buddhakanchana on 25/12/2566 BE.
//

import SwiftUI

struct ProfilePage: View {
    var body: some View {
        
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack{
                    
                    Text("My Profile")
                        .font(.custom(customFont, size:28).bold())
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(spacing: 25){
                        
                        Image("logo")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                            .offset(y: -30)
                            .padding(.bottom,-30)
                        
                        Text("Settawat Buddhakanchana")
                            .font(.custom(customFont, size: 16))
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
                    .padding([.horizontal,.bottom])
                    .background(
                        Color.white
                            .cornerRadius(12)
                    )
                    .padding()
                    .padding(.top, 40)
                    
                    // Custom Navigation Link
                    
                    CustomNavigationLink(title: "Edit Profile") {
                        Text("")
                            .navigationTitle("Edit Profile")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(LightGray.ignoresSafeArea())
                    }
                    
                    CustomNavigationLink(title: "Shoping Address") {
                        Text("")
                            .navigationTitle("Shoping Address")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(LightGray.ignoresSafeArea())
                    }
                    
                    CustomNavigationLink(title: "Order History") {
                        Text("")
                            .navigationTitle("Order History")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(LightGray.ignoresSafeArea())
                    }
                    
                    CustomNavigationLink(title: "Logout") {
                        Text("")
                            .navigationTitle("Logout")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(LightGray.ignoresSafeArea())
                    }
                    
                }
                .padding(.horizontal, 22)
                .padding(.vertical, 20)
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
                    .foregroundColor(title == "Logout" ? .red : .black)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(title == "Logout" ? .red : .black)
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
