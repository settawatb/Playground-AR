//
//  FilePickerViewModel.swift
//  Playground_AR
//
//  Created by Settawat Buddhakanchana on 26/2/2567 BE.
//

import SwiftUI
import PhotosUI
import UIKit

class FilePickerViewModel: NSObject, ObservableObject {
    @Published var selectedImages: [UIImage] = []
    @Published var selectedModel3D: URL?

    // Function to pick a single image
    func pickImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        // Present the image picker
        presentImagePicker(imagePicker)
    }

    // Function to pick multiple images
    func pickMultiImage() {
        // Configure PHPickerViewController
        var config = PHPickerConfiguration()
        config.selectionLimit = 0 // Set to 0 for unlimited selection
        config.filter = .images // Allow images only

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        // Present the picker
        presentImagePicker(picker)
    }

    // Present DocumentPicker for 3D models
    func pickModel3D() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.usdz], asCopy: true)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        // Present the document picker
        presentImagePicker(documentPicker)
    }

    private func presentImagePicker(_ picker: UIViewController) {
        if let keyWindow = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows
            .first(where: { $0.isKeyWindow }) {
            keyWindow.rootViewController?.present(picker, animated: true, completion: nil)
        }
    }
}

// Delegate methods for PHPickerViewController
extension FilePickerViewModel: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        // Process the selected images
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { (object, error) in
                if let image = object as? UIImage {
                    DispatchQueue.main.async {
                        self.selectedImages.append(image)
                    }
                }
            }
        }
        // Dismiss the picker
        picker.dismiss(animated: true, completion: nil)
    }
}

// Delegate methods for UIImagePickerController
extension FilePickerViewModel: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            selectedImages.append(image)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

// Delegate methods for UIDocumentPicker
extension FilePickerViewModel: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if let selectedModelURL = urls.first {
            selectedModel3D = selectedModelURL
        }
        controller.dismiss(animated: true, completion: nil)
    }
}
