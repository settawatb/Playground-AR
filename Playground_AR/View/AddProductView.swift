//
//  AddProductView.swift
//  Playground_AR
//
//  Created by Settawat Buddhakanchana on 26/2/2567 BE.
//

import SwiftUI
import Combine

struct AddProductView: View {
    @StateObject var loginData: LoginPageModel = LoginPageModel()
    @State private var productName = ""
    @State private var productPrice = ""
    @State private var productQuantity = 1
    @State private var selectedCategory = "Arttoy"
    @State private var productDescription = ""
    @StateObject private var filePickerViewModel = FilePickerViewModel()
    @State private var isFilePickerPresented = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var addProductSuccess = false
    
    @Environment(\.presentationMode) var presentationMode

    // Initialize navigation bar appearance
    init() {
        let appear = UINavigationBarAppearance()

        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: customFontBold, size: 20)!
        ]

        appear.largeTitleTextAttributes = attributes
        appear.titleTextAttributes = attributes
        UIBarButtonItem.appearance().tintColor = .black
        UINavigationBar.appearance().standardAppearance = appear
        UINavigationBar.appearance().compactAppearance = appear
        UINavigationBar.appearance().scrollEdgeAppearance = appear
    }
    
    private var productQuantityBinding: Binding<String> {
            Binding(
                get: {
                    return String(productQuantity)
                },
                set: { newValue in
                    // Convert the String back to an Int
                    if let intValue = Int(newValue) {
                        productQuantity = intValue
                    } else {
                        productQuantity = 0
                    }
                }
            )
        }

    var body: some View {
        ScrollView(){
     
            VStack(spacing: 10) {
            // File picker view for image and 3D model
            FilePickerView(viewModel: filePickerViewModel, allowedContentTypes: [.image, .usdz])
                .sheet(isPresented: $isFilePickerPresented) {}
            Divider().background(Color.black.opacity(0.4)).padding(.top, 20)
                // Product input fields and other views
                CustomTitle(icon: "signature", title: "Product Name")
                TextField("Enter Product Name", text: $productName)
                    .font(.custom(customFont, size: 12))
                    .foregroundColor(PurPle)
                Divider().background(Color.black.opacity(0.4))

                // Product Price input
                CustomTitle(icon: "bitcoinsign.circle", title: "Price")
                TextField("Enter Product Price", text: $productPrice)
                    .keyboardType(.numberPad)
                    .font(.custom(customFont, size:12))
                    .foregroundColor(PurPle)
                Divider().background(Color.black.opacity(0.4))
                
                CustomTitle(icon: "plusminus", title: "Quantity")
                TextField("Enter Product Quantity", text: productQuantityBinding)
                    .keyboardType(.numberPad)
                    .font(.custom(customFont, size:12))
                    .foregroundColor(PurPle)
                Divider().background(Color.black.opacity(0.4))

                // Product Quantity Stepper
//                Stepper {
//                    HStack(alignment: .center) {
//                        Label {
//                            Text("Quantity")
//                                .font(.custom(customFontBold, size: 14))
//                        } icon: {
//                            Image(systemName: "plusminus")
//                        }
//                        .foregroundColor(Color.black.opacity(0.8))
//
//                        Text("\(productQuantity)")
//                            .font(.custom(customFontBold, size: 14))
//                            .foregroundColor(PurPle)
//                            .padding(.horizontal, 8) // Add padding for spacing
//                    }
//                } onIncrement: {
//                    productQuantity += 1
//                } onDecrement: {
//                    if productQuantity > 1 {
//                        productQuantity -= 1
//                    }
//                }
//                Divider().background(Color.black.opacity(0.4))

                // Product Category Picker
                VStack {
                    Label {
                        Text("Category")
                            .font(.custom(customFontBold, size: 14))
                    } icon: {
                        Image(systemName: "puzzlepiece")
                            .resizable()
                            .frame(width:18, height: 15)
                    }
                    .foregroundColor(Color.black.opacity(0.8))
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Picker("Category", selection: $selectedCategory) {
                    Text("Arttoy").tag("Arttoy")
                    Text("Figure").tag("Figure")
                    Text("Doll").tag("Doll")
                    Text("Game").tag("Game")
                }
                .pickerStyle(.segmented)
                .padding(.bottom)
                Divider().background(Color.black.opacity(0.4))

                // Product Details Text Editor
                VStack {
                    Label {
                        Text("Detail")
                            .font(.custom(customFontBold, size: 14))
                    } icon: {
                        Image(systemName: "info.circle")
                            .resizable()
                            .frame(width:18, height: 18)
                    }
                    .foregroundColor(Color.black.opacity(0.8))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                ZStack(alignment: .topLeading) {
                    TextEditor(text: $productDescription)
                        .font(.custom(customFont, size: 14))
                        .foregroundColor(PurPle)
                        .frame(minHeight: 120)
                        .padding()
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 1)
                }
                .padding()
                Divider().background(Color.black.opacity(0.4))

                // Submit button
                Button(action: {
                    // Validate inputs before uploading
                    guard validateInputs() else {
                        return
                    }
                    
                    // Proceed with product upload
                    uploadProduct()
                }) {
                    Text("Submit Product")
                        .font(.custom(customFont, size: 20).bold())
                        .foregroundColor(Color.white)
                        .padding(.vertical, 20)
                        .frame(maxWidth: .infinity)
                        .background(PurPle)
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.06), radius: 5, x: 5, y: 5)
                        .padding()
                }
            }
            .padding(.top, 20)
            .frame(width: 350)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(addProductSuccess ? "Upload Successfully" : "Error"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK")) {
                        // If the upload was successful, navigate to MainPage
                        if addProductSuccess {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                )
            }
        }
        .onAppear {
            // Fetch user profile data on appear
            loginData.fetchUserProfile()
        }
    }

    // Validate user inputs
    func validateInputs() -> Bool {
        if productName.isEmpty {
            alertMessage = "Please enter a product name."
        } else if productPrice.isEmpty {
            alertMessage = "Please enter a product price."
        } else if productDescription.isEmpty {
            alertMessage = "Please enter a product description."
        } else if selectedCategory.isEmpty {
            alertMessage = "Please select a product category."
        } else {
            // Additional validation logic if necessary
            return true
        }
        showAlert = true
        return false
    }

    // Upload product and handle the result
    func uploadProduct() {
        let formData: [String: Any] = [
            "productName": productName,
            "productPrice": productPrice,
            "productQuantity": "\(productQuantity)",
            "productCategory": selectedCategory,
            "productDescription": productDescription,
            "productSellerId": loginData.id,
            "productSellerName": loginData.userName
        ]

        // Convert the image to data
        guard let imageData = filePickerViewModel.selectedImages.first?.pngData(),
              let model3DUrl = filePickerViewModel.selectedModel3D else {
            print("Error: Unable to retrieve image data or model URL")
            alertMessage = "Failed to retrieve image data or model URL."
            showAlert = true
            return
        }
        
        // Fetch model 3D data from URL
        NetworkManager.shared.fetchData(from: model3DUrl) { result in
            switch result {
            case .success(let model3DData):
                // Call your network manager to upload the product data
                NetworkManager.shared.uploadFiles(formData: formData, imageData: imageData, model3DData: model3DData) { result in
                    switch result {
                    case .success(let response):
                        // Handle success response
                        print("Product uploaded successfully:", response)
                        addProductSuccess = true
                        alertMessage = "Product uploaded successfully."
                        showAlert = true
                    case .failure(let error):
                        // Handle error
                        print("Error uploading product:", error)
                        alertMessage = "Failed to upload product. Please try again."
                        showAlert = true
                    }
                }
            case .failure(let error):
                // Handle error fetching model 3D data
                print("Error fetching model 3D data:", error)
                alertMessage = "Failed to fetch model 3D data. Please try again."
                showAlert = true
            }
        }
    }
}


// Define the custom title view
@ViewBuilder
func CustomTitle(icon: String, title: String) -> some View {
    VStack(alignment: .leading) {
        Label {
            Text(title)
                .font(.custom(customFontBold, size: 14))
        } icon: {
            Image(systemName: icon)
                .resizable()
                .frame(width:18, height: 15)
        }
        .foregroundColor(Color.black.opacity(0.8))
    }
    .frame(maxWidth: .infinity, alignment: .leading)
}

struct AddProductView_Previews: PreviewProvider {
    static var previews: some View {
        AddProductView()
    }
}
