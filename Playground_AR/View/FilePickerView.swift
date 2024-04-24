//
//  FilePickerView.swift
//  Playground_AR
//
//  Created by Settawat Buddhakanchana on 26/2/2567 BE.
//

import SwiftUI
import UniformTypeIdentifiers

struct FilePickerView: View {
    @ObservedObject var viewModel: FilePickerViewModel
    var allowedContentTypes: [UTType]
    
    @State var currentIndex = 0
    
    var body: some View {
        VStack {
            // Button to pick new images
            Button(action: {
                viewModel.pickMultiImage()
            }) {
                if !viewModel.selectedImages.isEmpty {
                    ZStack(alignment: .topTrailing) {
                        // Delete button for the current image
                            Image(uiImage: viewModel.selectedImages[currentIndex])
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 260, height: 260)
                                .cornerRadius(10)
                                .shadow(radius: 2)
                                .padding(.horizontal, 10)
                        
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
                } else {
                    UploadImageView()
                }
            }.foregroundColor(.black)
            HStack{
                if !viewModel.selectedImages.isEmpty {
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
                    
                Text("Image \(currentIndex + 1) of \(viewModel.selectedImages.count)")
                    .font(.custom(customFont, size: 15))
                    .foregroundColor(Color.black)
                    .frame(maxWidth: 230, maxHeight: 30)
                    .shadow(color: Color.black.opacity(0.06), radius: 5, x: 5, y: 5)
                    
                    
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
                    .disabled(currentIndex >= viewModel.selectedImages.count - 1) // Disable if at the last image
            }}

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
                }else{
                VStack {
                    Image(systemName: "cube.transparent")
                        .resizable()
                        .frame(width: 55, height: 55)
                        .foregroundColor(PurPle)
                    Text("Upload your 3D Model")
                        .font(.custom(customFontBold, size: 14))
                    Text("Try to upload more files to see them here")
                        .font(.custom(customFont, size: 14))
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(style: StrokeStyle(lineWidth: 2, dash: [6, 6]))
                        .foregroundColor(PurPle)
                )
            }}
            .foregroundColor(Color.black)
            .padding(.top,20)

        }
    }
}

struct UploadImageView: View {
    var body: some View {
        VStack {
            Image(systemName: "icloud.and.arrow.up.fill")
                .resizable()
                .frame(width: 85, height: 75)
                .foregroundColor(PurPle)
            Text("Upload your images")
                .font(.custom(customFontBold, size: 14))
            Text("Try to upload more files to see them here")
                .font(.custom(customFont, size: 14))
        }
        .padding()
        .frame(height: 260)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(style: StrokeStyle(lineWidth: 2, dash: [6, 6]))
                .foregroundColor(PurPle)
        )
    }
}

struct FilePickerView_Previews: PreviewProvider {
    static var previews: some View {
        FilePickerView(viewModel: FilePickerViewModel(), allowedContentTypes: [.image, .usdz])
            .previewDisplayName("FilePickerView Preview")
    }
}


