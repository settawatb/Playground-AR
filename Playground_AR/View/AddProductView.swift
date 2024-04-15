//
//  AddProductView.swift
//  Playground_AR
//
//  Created by Settawat Buddhakanchana on 26/2/2567 BE.
//

import SwiftUI

struct AddProductView: View {
    @StateObject var loginData: LoginPageModel = LoginPageModel()
    @State private var productName = ""
    @State private var productPrice = ""
    @State private var productQuantity = 1
    @State private var selectedCategory = "Arttoy"
    @State private var productDescription = ""
    @StateObject private var filePickerViewModel = FilePickerViewModel()
    @State private var isFilePickerPresented = false // Placeholder variable
    
    var body: some View {
        VStack {
            FilePickerView(viewModel: filePickerViewModel, allowedContentTypes: [.image, .usdz])
                .sheet(isPresented: $isFilePickerPresented) {
                    // Handle the result after file selection if needed
                    // Currently, it just dismisses the sheet
                }
            
            TextField("Product Name", text: $productName)
                .padding()
            Divider()
                .background(Color.black.opacity(0.4))
            
            TextField("Product Price", text: $productPrice)
                .keyboardType(.numberPad)
                .padding()
            Divider()
                .background(Color.black.opacity(0.4))
            
            Stepper("Product Quantity: \(productQuantity)", value: $productQuantity, in: 1...999)
                .padding()
            Divider()
                .background(Color.black.opacity(0.4))
            
            Text("Product Category")
            Picker("Product Category", selection: $selectedCategory) {
                Text("Arttoy").tag("Arttoy")
                Text("Figure").tag("Figure")
                Text("Doll").tag("Doll")
                Text("Anime").tag("Anime")
                // Add more categories as needed
            }
            .pickerStyle(.segmented)
            .padding()
            Divider()
                .background(Color.black.opacity(0.4))
            
            Text("Product details")
            ZStack(alignment: .topLeading) {
                TextEditor(text: $productDescription)
                    .frame(minHeight: 50)
                    .padding()
                
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.black, lineWidth: 1)
            }
            .padding()
            
            Button(action: {
                
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
                            case .failure(let error):
                                // Handle error
                                print("Error uploading product:", error)
                            }
                        }
                    case .failure(let error):
                        // Handle error
                        print("Error fetching model 3D data:", error)
                    }
                }
            }) {
                Text("Submit Product")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()



        }.onAppear {
            loginData.fetchUserProfile()
        }
    }
    
}

struct AddProductView_Previews: PreviewProvider {
    static var previews: some View {
        AddProductView()
    }
}
