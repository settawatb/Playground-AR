//
//  ProfileImagePickerViewModel.swift
//  Playground_AR
//
//  Created by Settawat Buddhakanchana on 21/4/2567 BE.
//

import SwiftUI
import UIKit

class ProfileImagePickerViewModel: NSObject, ObservableObject {
    @Published var selectedImage: UIImage?

    // Present ImagePicker to pick a single image
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
}

extension ProfileImagePickerViewModel: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        // Obtain the original image selected by the user
        if let image = info[.originalImage] as? UIImage {
            // Set the selected image
            selectedImage = image
        }
        // Dismiss the image picker
        picker.dismiss(animated: true, completion: nil)
    }
}
