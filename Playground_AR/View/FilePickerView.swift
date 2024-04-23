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
            if !viewModel.selectedImages.isEmpty {
                ZStack(alignment: .topTrailing) {
                    // Delete button for the current image
                    
                        Image(uiImage: viewModel.selectedImages[currentIndex])
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 230, height: 230)
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
                    .padding()
                    
                }
            } else {
                Image("image_placeholder")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 230, height: 230)
                    .cornerRadius(10)
                    .shadow(radius: 2)
            }

            // Display text for the index page of the currently displayed page
            HStack{
                if !viewModel.selectedImages.isEmpty {
                    Button(action: {
                        if currentIndex > 0 {
                            withAnimation {
                                currentIndex -= 1
                            }
                        }
                    }) {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .frame(width: 15, height: 20)
                            .foregroundColor(currentIndex > 0 ? PurPle : .gray)
                    }
                    .disabled(currentIndex <= 0)
                    
                Text("Image \(currentIndex + 1) of \(viewModel.selectedImages.count)")
                    .font(.custom(customFont, size: 15))
                    .foregroundColor(Color.white)
                    .frame(maxWidth: 230, maxHeight: 30)
                    .background(Color.gray)
                    .shadow(color: Color.black.opacity(0.06), radius: 5, x: 5, y: 5)
                    
                    
                    // Next image button
                    Button(action: {
                        if currentIndex < viewModel.selectedImages.count - 1 {
                            withAnimation {
                                currentIndex += 1
                            }
                        }
                    }) {
                        Image(systemName: "chevron.right")
                            .resizable()
                            .frame(width: 15, height: 20)
                            .foregroundColor(currentIndex < viewModel.selectedImages.count - 1 ? PurPle : .gray)
                    }
                    .disabled(currentIndex >= viewModel.selectedImages.count - 1) // Disable if at the last image
            }}
            
            
            // Button to pick new images
            Button(action: {
                viewModel.pickMultiImage()
            }) {
                Label {
                    Text("Upload Images")
                        .font(.custom(customFont, size: 14).bold())
                } icon: {
                    Image(systemName: "photo.badge.plus")
                }
            }
            .foregroundColor(Color.white)
            .frame(width: 230, height: 50)
            .background(Color.black)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.06), radius: 5, x: 5, y: 5)
            .padding(.bottom, 20)
            .padding(.top, viewModel.selectedImages.isEmpty ? 15 : 0)

            Divider()

            // Button to pick a model 3D file
            Button(action: {
                viewModel.pickModel3D()
            }) {
                Label {
                    Text("Upload Model 3D")
                        .font(.custom(customFont, size: 14).bold())
                } icon: {
                    Image(systemName: "scale.3d")
                }
            }
            .foregroundColor(Color.white)
            .frame(width: 230, height: 50)
            .background(Color.black)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.06), radius: 5, x: 5, y: 5)
            .padding()

            // Display selected model 3D file name
            if let selectedModel3D = viewModel.selectedModel3D {
                Text("Selected Model 3D: \(selectedModel3D.lastPathComponent)")
                    .font(.custom(customFont, size: 14))
                    .foregroundColor(Color.white)
                    .frame(maxWidth: 230, maxHeight: 30)
                    .background(Color.gray)
                    .shadow(color: Color.black.opacity(0.06), radius: 5, x: 5, y: 5)
            }
        }
        .padding(.top, 20)
    }
}

struct FilePickerView_Previews: PreviewProvider {
    static var previews: some View {
        FilePickerView(viewModel: FilePickerViewModel(), allowedContentTypes: [.image, .usdz])
            .previewDisplayName("FilePickerView Preview")
    }
}

