//
//  EditProductView.swift
//  Playground_AR
//
//  Created by Settawat Buddhakanchana on 29/4/2567 BE.
//

import SwiftUI
import UniformTypeIdentifiers

struct EditProductView: View {
    var product: ProductBySeller
    var productImages: [String]
    
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
    @State private var displayImage: Bool = false
    @State private var showConfirmationAlert = false
    @State private var deletionSuccessful = false
    @State private var showDeleteConfirmationAlert = false
    @State private var showDelAlert: Bool = false
    
    
    
    @Environment(\.presentationMode) var presentationMode
    
    // Initialize state properties in the initializer
    init(product: ProductBySeller, productImages: [String]) {
        self.productImages = productImages
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
                

                FilePickerViewForEdit(viewModel: filePickerViewModel, allowedContentTypes: [.image, .usdz], productImages: product.productImages)
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
                    // Check if user inputs are valid
                    guard validateInputs() else {
                        return
                    }

                    
                    showConfirmationAlert = true
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

                
                Divider().background(Color.black.opacity(0.4))
                
                // Delete product button
                Button(action: {
                    // Show confirmation alert
                    showDeleteConfirmationAlert = true
                }) {
                    Text("Delete Product")
                        .font(.custom(customFont, size: 20).bold())
                        .foregroundColor(Color.white)
                        .padding(.vertical, 20)
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.06), radius: 5, x: 5, y: 5)
                        .padding()
                }
            }
            .padding(.top, 20)
            .padding(.horizontal)
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            // Alerts
            .alert(
                "Update Successful",
                isPresented: $showAlert,
                actions: {
                    Button("OK") {
                        if addProductSuccess {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                },
                message: {
                    Text(alertMessage)
                }
            )
            .alert(
                "Confirm Update",
                isPresented: $showConfirmationAlert,
                actions: {
                    Button("Yes") {
                        updateProduct()
                    }
                    Button("No") {}
                },
                message: {
                    Text("Are you sure you want to update this product?")
                }
            )
            .alert(
                "Confirm Delete",
                isPresented: $showDeleteConfirmationAlert,
                actions: {
                    Button("Delete") {
                        deleteProduct()
                    }
                    Button("Cancel", role: .cancel) {}
                },
                message: {
                    Text("Are you sure you want to delete this product?")
                }
            )
            .alert(
                "Delete Product",
                isPresented: $showDelAlert,
                actions: {
                    Button("OK") {
                        if deletionSuccessful {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                },
                message: {
                    Text(alertMessage)
                }
            )
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
        let formData: [String: Any] = [
            "productName": productName,
            "productPrice": Double(productPrice) ?? 0.0,
            "productQuantity": productQuantity,
            "productCategory": selectedCategory,
            "productDescription": productDescription,
            "productSellerId": loginData.id,
            "productSellerName": loginData.userName,
            "productSellerAddress:": loginData.address,
        ]

        var imageDataArray: [Data]?
        if !filePickerViewModel.selectedImages.isEmpty {
            imageDataArray = []
            for image in filePickerViewModel.selectedImages {
                if let data = image.pngData() {
                    imageDataArray?.append(data)
                }
            }
        }


        var model3DData: Data?
        if let model3DUrl = filePickerViewModel.selectedModel3D {
            NetworkManager.shared.fetchData(from: model3DUrl) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let data):
                        model3DData = data
                        performUpdateProduct(formData: formData, imageDataArray: imageDataArray, model3DData: model3DData)
                    case .failure(let error):
                        print("Error fetching 3D model data:", error)
                        alertMessage = "Failed to fetch 3D model data. Please try again."
                        showAlert = true
                    }
                }
            }
            return
        } else {
            // If no new 3D model file has been selected, proceed without model3DData
            model3DData = nil
        }

        performUpdateProduct(formData: formData, imageDataArray: imageDataArray, model3DData: model3DData)
    }

    func performUpdateProduct(formData: [String: Any], imageDataArray: [Data]?, model3DData: Data?) {
        let imageDataArray = imageDataArray ?? []
        NetworkManager.shared.updateProduct(productID: productID, formData: formData, imageDataArray: imageDataArray, model3DData: model3DData) { updateResult in
            handleUpdateResult(updateResult)
        }
    }

    func handleUpdateResult(_ updateResult: Result<[String: Any], Error>) {
        DispatchQueue.main.async {
            switch updateResult {
            case .success:
                print("Product updated successfully.")
                addProductSuccess = true
                alertMessage = "Product updated successfully."
                showAlert = true
            case .failure(let error):
                print("Error updating product:", error)
                alertMessage = "Failed to update product. Please try again."
                showAlert = true
            }
        }
    }

    // Implement deleteProduct function
    func deleteProduct() {
        // Call the NetworkManager's deleteProduct function
        NetworkManager.shared.deleteProduct(productID: productID) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    deletionSuccessful = true
                    alertMessage = "Product deleted successfully."
                    showDelAlert = true
                case .failure(let error):
                    print("Error deleting product:", error)
                    alertMessage = "Failed to delete product. Please try again."
                    showDelAlert = true
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


struct ImageSlider: View {
    var images: [String]
    @State private var currentIndex = 0
    
    var body: some View {
        VStack {
            ZStack(alignment: .topTrailing) {
                // Display the current image
                AsyncImage(url: URL(string: images[currentIndex])) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 260, height: 260)
                            .cornerRadius(10)
                            .shadow(radius: 2)
                            .padding(.horizontal, 10)
                    case .failure:
                        Image("image_placeholder")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 260, height: 260)
                            .cornerRadius(10)
                            .shadow(radius: 2)
                            .padding(.horizontal, 10)
                    default:
                        ProgressView()
                            .frame(width: 260, height: 260)
                    }
                }
            }
            
            HStack {
                Button(action: {
                    if currentIndex > 0 {
                        currentIndex -= 1
                    }
                }) {
                    Image(systemName: "arrowshape.left.fill")
                        .resizable()
                        .frame(width: 20, height: 16)
                        .foregroundColor(currentIndex > 0 ? PurPle : .gray)
                }
                .disabled(currentIndex <= 0)

                // Display current image index
                Text("Image \(currentIndex + 1) of \(images.count)")
                    .font(.custom(customFont, size: 15))
                    .foregroundColor(.black)

                // Next button
                Button(action: {
                    if currentIndex < images.count - 1 {
                        currentIndex += 1
                    }
                }) {
                    Image(systemName: "arrowshape.right.fill")
                        .resizable()
                        .frame(width: 20, height: 16)
                        .foregroundColor(currentIndex < images.count - 1 ? PurPle : .gray)
                }
                .disabled(currentIndex >= images.count - 1)
            }
            .padding(.top, 8)
        }
    }
}




struct FilePickerViewForEdit: View {
    @ObservedObject var viewModel: FilePickerViewModel
    var allowedContentTypes: [UTType]
    var productImages: [String] // Array of product images from EditProductView
    
    @State var currentIndex = 0
    
    var body: some View {
        VStack {
            // Button to pick new images
            Button(action: {
                viewModel.pickMultiImage()
            }) {
                if viewModel.selectedImages.isEmpty {
                    ImageSlider(images: productImages)
                        .frame(width: 300, height: 300)
                        .cornerRadius(10)
                } else {
                    ZStack(alignment: .topTrailing) {
                        // Display the selected image
                        Image(uiImage: viewModel.selectedImages[currentIndex])
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 260, height: 260)
                            .cornerRadius(10)
                            .shadow(radius: 2)
                            .padding(.horizontal, 10)
                        
                        // Button to delete the current image
                        Button(action: {
                            viewModel.selectedImages.remove(at: currentIndex)
                            
                            // Adjust the current index after deletion
                            if viewModel.selectedImages.isEmpty {
                                currentIndex = 0
                            } else {
                                // If the current index is now out of range, adjust it to be within range
                                currentIndex = min(currentIndex, viewModel.selectedImages.count - 1)
                            }
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.red)
                        }
                        .background(Color.white)
                        .clipShape(Circle())
                        .padding(.top, 8)
                        .padding(.trailing, 18)
                    }
                }
            }
            .foregroundColor(.black)
            
            // Image navigation controls (arrows and index display)
            if !viewModel.selectedImages.isEmpty {
                HStack {
                    // Previous image button
                    Button(action: {
                        if currentIndex > 0 {
                            withAnimation {
                                currentIndex -= 1
                            }
                        }
                    }) {
                        Image(systemName: "arrowshape.left.fill")
                            .resizable()
                            .frame(width: 20, height: 16)
                            .foregroundColor(currentIndex > 0 ? PurPle : .gray)
                    }
                    .disabled(currentIndex <= 0)
                    
                    // Display the current image index
                    Text("Image \(currentIndex + 1) of \(viewModel.selectedImages.count)")
                        .font(.custom(customFont, size: 15))
                        .foregroundColor(.black)
                        .frame(maxWidth: 230, maxHeight: 30)
                        .shadow(color: .black.opacity(0.06), radius: 5, x: 5, y: 5)
                    
                    // Next image button
                    Button(action: {
                        if currentIndex < viewModel.selectedImages.count - 1 {
                            withAnimation {
                                currentIndex += 1
                            }
                        }
                    }) {
                        Image(systemName: "arrowshape.right.fill")
                            .resizable()
                            .frame(width: 20, height: 16)
                            .foregroundColor(currentIndex < viewModel.selectedImages.count - 1 ? PurPle : .gray)
                    }
                    .disabled(currentIndex >= viewModel.selectedImages.count - 1)
                }
            }
            
            Divider()
            
            // Button to pick a model 3D file
            Button(action: {
                viewModel.pickModel3D()
            }) {
                // Display selected model 3D file name
                if let selectedModel3D = viewModel.selectedModel3D {
                    VStack {
                        Image(systemName: "cube.box")
                            .resizable()
                            .frame(width: 55, height: 55)
                            .foregroundColor(.green)
                        
                        Text("Selected 3D Model:")
                            .font(.custom(customFontBold, size: 14))
                        Text("\(selectedModel3D.lastPathComponent)")
                            .font(.custom(customFontBold, size: 14))
                            .padding(.bottom, 6)
                        
                        Button(action: {
                            viewModel.selectedModel3D = nil
                        }) {
                            Text("Cancel Select")
                                .font(.custom(customFontBold, size: 14))
                                .underline()
                                .foregroundColor(.red)
                        }
                    }
                } else {
                    VStack {
                        Image(systemName: "cube.transparent")
                            .resizable()
                            .frame(width: 55, height: 55)
                            .foregroundColor(PurPle)
                        
                        Text("Use the same file that you have already uploaded.")
                            .font(.custom(customFontBold, size: 14))
                        Text("If you want to change the 3d model file, press for upload again.")
                            .font(.custom(customFont, size: 14))
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(style: StrokeStyle(lineWidth: 2, dash: [6, 6]))
                            .foregroundColor(PurPle)
                    )
                }
            }
            .foregroundColor(Color.black)
            .padding(.top,20)
        }
    }
}

