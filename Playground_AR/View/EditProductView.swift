//
//  EditProductView.swift
//  Playground_AR
//
//  Created by Settawat Buddhakanchana on 29/4/2567 BE.
//

import SwiftUI

struct EditProductView: View {
    var product: ProductBySeller
    
    @StateObject var loginData = LoginPageModel()
    @StateObject private var filePickerViewModel = FilePickerViewModel()
    @State private var productID: String
    @State private var productName: String
    @State private var productPrice: String
    @State private var productQuantity: Int
    @State private var selectedCategory: String
    @State private var productDescription: String
    @State private var isFilePickerPresented: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var addProductSuccess: Bool = false
    
    @Environment(\.presentationMode) var presentationMode
    
    // Initialize state properties in the initializer
    init(product: ProductBySeller) {
        self.product = product
        self._productName = State(initialValue: product.title)
        self._productPrice = State(initialValue: String(product.price))
        self._productQuantity = State(initialValue: product.quantity)
        self._selectedCategory = State(initialValue: product.type.first ?? "")
        self._productDescription = State(initialValue: product.description)
        self._productID = State(initialValue: product.id)
        
        // Initialize navigation appearance
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.font: UIFont(name: customFontBold, size: 20)!]
        appearance.largeTitleTextAttributes = appearance.titleTextAttributes
        UIBarButtonItem.appearance().tintColor = .black
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }


    // Binding for product quantity
    private var productQuantityBinding: Binding<String> {
        Binding(
            get: { String(productQuantity) },
            set: { newValue in
                if let intValue = Int(newValue) {
                    productQuantity = intValue
                } else {
                    productQuantity = 0
                }
            }
        )
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                // File picker view for image and 3D model
                FilePickerView(viewModel: filePickerViewModel, allowedContentTypes: [.image, .usdz])
                    .sheet(isPresented: $isFilePickerPresented) {}

                Divider().background(Color.black.opacity(0.4)).padding(.top, 20)

                // Custom Title and TextField views
                CustomTitleEdit(icon: "signature", title: "Product Name")
                TextField("Enter Product Name", text: $productName)
                    .font(.custom(customFont, size: 12))
                    .foregroundColor(PurPle)
                Divider().background(Color.black.opacity(0.4))

                CustomTitleEdit(icon: "bitcoinsign.circle", title: "Price")
                TextField("Enter Product Price", text: $productPrice)
                    .keyboardType(.decimalPad)
                    .font(.custom(customFont, size: 12))
                    .foregroundColor(PurPle)
                Divider().background(Color.black.opacity(0.4))

                CustomTitleEdit(icon: "plusminus", title: "Quantity")
                TextField("Enter Product Quantity", text: productQuantityBinding)
                    .keyboardType(.numberPad)
                    .font(.custom(customFont, size:12))
                    .foregroundColor(PurPle)
                Divider().background(Color.black.opacity(0.4))

                // Product Category Picker
                VStack {
                    Label {
                        Text("Category")
                            .font(.custom(customFontBold, size: 14))
                    } icon: {
                        Image(systemName: "puzzlepiece")
                            .resizable()
                            .frame(width: 18, height: 15)
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
                .pickerStyle(SegmentedPickerStyle())
                .padding(.bottom)
                Divider().background(Color.black.opacity(0.4))


                CustomTitleEdit(icon: "info.circle", title: "Detail")
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
                    guard validateInputs() else {
                        return
                    }

                    // Proceed with product update
                    updateProduct()
                }) {
                    Text("Update Product")
                        .font(.custom(customFont, size: 20).bold())
                        .foregroundColor(Color.white)
                        .padding(.vertical, 20)
                        .frame(maxWidth: .infinity)
                        .background(PurPle)
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.06), radius: 5, x: 5, y: 5)
                        .padding()
                }
                
                // Delete product button
                Button(action: {
                    // action for delete product
                }) {
                    Text("Delete Product")
                        .font(.custom(customFont, size: 20).bold())
                        .foregroundColor(Color.white)
                        .padding(.vertical, 20)
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.06), radius: 5, x: 5, y: 5)
                }
            }
            .padding(.top, 20)
            .frame(width: 350)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(addProductSuccess ? "Update Successful" : "Error"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK")) {
                        if addProductSuccess {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                )
            }
        }
    }

    // Validate user inputs
    func validateInputs() -> Bool {
        if productName.isEmpty {
            alertMessage = "Please enter a product name."
            return false
        } else if productPrice.isEmpty {
            alertMessage = "Please enter a product price."
            return false
        } else if productDescription.isEmpty {
            alertMessage = "Please enter a product description."
            return false
        } else if selectedCategory.isEmpty {
            alertMessage = "Please select a product category."
            return false
        } else {
            return true
        }
    }

    // Update product data
    func updateProduct() {
        // Prepare form data
        let formData: [String: Any] = [
            "productName": productName,
            "productPrice": Double(productPrice) ?? 0.0,
            "productQuantity": productQuantity,
            "productCategory": selectedCategory,
            "productDescription": productDescription,
            "productSellerId": loginData.id,
            "productSellerName": loginData.userName
        ]

        // Upload images and 3D model
        var imageDataArray: [Data] = []
        for image in filePickerViewModel.selectedImages {
            if let data = image.pngData() {
                imageDataArray.append(data)
            }
        }

        guard let model3DUrl = filePickerViewModel.selectedModel3D else {
            alertMessage = "Failed to retrieve 3D model URL."
            showAlert = true
            return
        }

        // Fetch data from the 3D model URL
        NetworkManager.shared.fetchData(from: model3DUrl) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model3DData):
                    // Update product via NetworkManager
                    NetworkManager.shared.updateProduct(productID: productID, formData: formData, imageDataArray: imageDataArray, model3DData: model3DData) { updateResult in
                        switch updateResult {
                        case .success:
                            addProductSuccess = true
                            alertMessage = "Product updated successfully."
                            showAlert = true
                        case .failure(let error):
                            print("Error updating product:", error)
                            alertMessage = "Failed to update product. Please try again."
                            showAlert = true
                        }
                    }
                case .failure(let error):
                    print("Error fetching 3D model data:", error)
                    alertMessage = "Failed to fetch 3D model data. Please try again."
                    showAlert = true
                }
            }
        }

    }
}

struct CustomTitleEdit: View {
    let icon: String
    let title: String

    var body: some View {
        VStack(alignment: .leading) {
            Label {
                Text(title)
                    .font(.custom(customFontBold, size: 14))
            } icon: {
                Image(systemName: icon)
                    .resizable()
                    .frame(width: 18, height: 15)
            }
            .foregroundColor(Color.black.opacity(0.8))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

