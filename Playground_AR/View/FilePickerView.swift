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

    var body: some View {
        VStack {
            Button("Pick Images") {
                viewModel.pickImage()
            }
            .font(.custom(customFont, size: 20).bold())
            .foregroundColor(Color.white)
            .padding(.vertical, 20)
            .frame(maxWidth: .infinity)
            .background(Color.black)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.06), radius: 5, x: 5, y: 5)
            .padding()

            // Display selected images horizontally
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(viewModel.selectedImages.indices, id: \.self) { index in
                        ZStack(alignment: .topTrailing) {
                            Image(uiImage: viewModel.selectedImages[index])
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .cornerRadius(20)
                                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 3)

                            // Delete button for each image
                            Button(action: {
                                viewModel.selectedImages.remove(at: index)
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.red)
                                    .padding(5)
                            }
                            .background(Color.white)
                            .clipShape(Circle())
                            .opacity(0.7)
                            .padding(5)
                        }
                        .padding()
                    }
                }
                .padding(.horizontal, 20)
            }

            Button("Pick Model 3D") {
                viewModel.pickModel3D()
            }
            .font(.custom(customFont, size: 20).bold())
            .foregroundColor(Color.white)
            .padding(.vertical, 20)
            .frame(maxWidth: .infinity)
            .background(Color.black)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.06), radius: 5, x: 5, y: 5)
            .padding()

            // Display selected model 3D file name
            if let selectedModel3D = viewModel.selectedModel3D {
                Text("Selected Model 3D: \(selectedModel3D.lastPathComponent)")
                    .padding()
                    .multilineTextAlignment(.center)
            }
        }
    }
}

struct FilePickerView_Previews: PreviewProvider {
    static var previews: some View {
        FilePickerView(viewModel: FilePickerViewModel(), allowedContentTypes: [.image, .usdz])
            .previewDisplayName("FilePickerView Preview")
    }
}
