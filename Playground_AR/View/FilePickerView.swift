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
            // Display selected images horizontally
            VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .center){
                        ForEach(viewModel.selectedImages.indices, id: \.self) { index in
                            ZStack(alignment: .topTrailing) {
                                Image(uiImage: viewModel.selectedImages[index])
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 165, height: 165)
                                    .cornerRadius(5)
                                    .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 3)

                                // Delete button for each image
                                Button(action: {
                                    viewModel.selectedImages.remove(at: index)
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(.red)
                                        .padding(2)
                                }
                                .background(Color.white)
                                .clipShape(Circle())
                                .padding(5)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                    }
            Button(action: {
                viewModel.pickImage()
            }) {
                Text("Pick Images")
                    .font(.custom(customFont, size: 20).bold())
                    .foregroundColor(Color.white)
                    .padding(.vertical, 20)
                    .frame(maxWidth: .infinity)
                    .background(Color.black)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.06), radius: 5, x: 5, y: 5)
                    .padding()
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
                    .font(.custom(customFont, size: 18))
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
