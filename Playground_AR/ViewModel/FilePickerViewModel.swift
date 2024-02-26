//
//  FilePickerViewModel.swift
//  Playground_AR
//
//  Created by Settawat Buddhakanchana on 26/2/2567 BE.
//

import SwiftUI
import UniformTypeIdentifiers

class FilePickerViewModel: NSObject, ObservableObject {
    @Published var selectedImages: [UIImage] = []
    @Published var selectedModel3D: URL?

    // Present ImagePicker
    func pickImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        // Use the key window scene to get the root view controller
        if let keyWindow = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows
            .first(where: { $0.isKeyWindow }) {
            keyWindow.rootViewController?.present(imagePicker, animated: true, completion: nil)
        }
    }

    // Present DocumentPicker for 3D models
    func pickModel3D() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.usdz], asCopy: true)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        // Use the key window scene to get the root view controller
        if let keyWindow = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows
            .first(where: { $0.isKeyWindow }) {
            keyWindow.rootViewController?.present(documentPicker, animated: true, completion: nil)
        }
    }
}

extension FilePickerViewModel: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            selectedImages.append(image)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

// Separate extension for UIDocumentPickerDelegate
extension FilePickerViewModel: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if let selectedModelURL = urls.first {
            selectedModel3D = selectedModelURL
        }
        controller.dismiss(animated: true, completion: nil)
    }
}

