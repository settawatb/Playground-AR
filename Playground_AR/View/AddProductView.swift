//
//  AddProductView.swift
//  Playground_AR
//
//  Created by Settawat Buddhakanchana on 26/2/2567 BE.
//

import SwiftUI

struct AddProductView: View {
    @State private var productName = ""
    @State private var productPrice = ""
    @State private var productQuantity = 1
    @State private var selectedCategory = "Arttoy"
    @State private var productDescription = ""
    @StateObject private var filePickerViewModel = FilePickerViewModel()
    @State private var isFilePickerPresented = false // Placeholder variable
    
    var body: some View {
        VStack {
//            Text("Add Product")
//                .font(.title)
//                .padding()
            
            // Upload product_images
            FilePickerView(viewModel: filePickerViewModel, allowedContentTypes: [.image, .usdz])
                .sheet(isPresented: $isFilePickerPresented) {
                    // This block of code is executed when the sheet is dismissed
                    // You can put the logic to present AddProductView here
                    AddProductView()
                }
            
            // TextFields and other input controls
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
            
            // Button for product submission
            Button(action: {
                // Add logic for submitting the product details to the database
                // You can access the entered details from the @State variables
            }) {
                Text("Submit Product")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
        }
    }
}

struct AddProductView_Previews: PreviewProvider {
    static var previews: some View {
        AddProductView()
    }
}
