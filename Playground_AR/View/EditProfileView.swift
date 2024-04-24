//
//  EditProfileView.swift
//  Playground_AR
//
//  Created by Settawat Buddhakanchana on 18/4/2567 BE.
//
import SwiftUI

struct EditProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var loginData: LoginPageModel = LoginPageModel()
    @StateObject var profileImagePickerViewModel = ProfileImagePickerViewModel()
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var updateProfileSuccess = false

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 15) {
                // Button to pick an image for the profile picture
                Button(action: {
                    profileImagePickerViewModel.pickImage()
                }) {
                    if let imageData = loginData.image {
                                                Image(uiImage: UIImage(data: imageData) ?? UIImage())
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: 200, height: 200)
                                                    .clipShape(Circle())
                                            } else {
                                                // Placeholder image
                                                Image("user_placeholder")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: 200, height: 200)
                                                    .clipShape(Circle())
                                            }
                }
                .padding(.top, 8)
                .padding(.horizontal)
                // Observe the selected image and update loginData.image
                .onReceive(profileImagePickerViewModel.$selectedImage) { image in
                    if let selectedImage = image {
                        loginData.image = selectedImage.jpegData(compressionQuality: 0.8)
                    }
                }
                
                // Text fields for user inputs
                Text($loginData.userName.wrappedValue.isEmpty ? "username01" : $loginData.userName.wrappedValue)
                    .font(.custom(customFontBold, size: 20))
                Divider()
                    .background(Color.black.opacity(0.4))
                CustomTextFieldEdit(icon: "phone", title: "Telephone Number", hint: "09XXXXXXXX", value: $loginData.phoneNum, showPassword: .constant(false))
                CustomTextFieldEdit(icon: "envelope", title: "Email", hint: "sample@mail.com", value: $loginData.email, showPassword: .constant(false))
                CustomTextFieldEdit(icon: "mappin.and.ellipse", title: "Address", hint: "your address", value: $loginData.address, showPassword: .constant(false))
                DateOfBirthPicker(selectedDate: $loginData.dateOfBirth)
                    .padding(.top, 20)


                // Submit button
                Button(action: {
                    loginData.updateUserProfile { result in
                        switch result {
                        case .success:
                            alertMessage = "Update Profile Successfully"
                            updateProfileSuccess = true
                        case .failure(let error):
                            alertMessage = loginData.errorMessage(for: error)
                            updateProfileSuccess = false
                        }
                        showAlert = true
                    }
                }) {
                    Text("Submit")
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
                    Alert(title: Text(updateProfileSuccess ? "Update Profile Successfully" : "Error"),
                          message: Text(alertMessage),
                          dismissButton: .default(Text("OK")) {
                            if updateProfileSuccess {
                                withAnimation {
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }
                        })
                }
            }
            .padding(30)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white.ignoresSafeArea())
        .onAppear {
            loginData.fetchUserProfile()
        }
    }
}

@ViewBuilder
func CustomTextFieldEdit(icon: String, title: String, hint: String, value: Binding<String>, showPassword: Binding<Bool>) -> some View {
    VStack(alignment: .leading, spacing: 12) {
        // Label for the title with icon
        Label {
            Text(title)
                .font(.custom(customFontBold, size: 14))
        } icon: {
            Image(systemName: icon)
        }
        .foregroundColor(Color.black.opacity(0.8))
        if title.contains("Username") {
            TextField(hint, text: value)
                .background(Color.black.opacity(0.1))
                .padding(.top, 2)
                .disableAutocorrection(true)
                .frame(width: .infinity, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .cornerRadius(15)
                .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
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
                    .stroke(Color.black.opacity(0.1), lineWidth: 1)
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
}

#Preview {
    EditProfileView()
}
