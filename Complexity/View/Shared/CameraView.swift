//
//  CameraView.swift
//  Complexity
//
//  Created by IE12 on 30/04/24.
//
import SwiftUI
import PhotosUI
import UIKit

class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var picker: CameraView
    var selectedImage: UIImage = UIImage()
    init(picker: CameraView) {
        self.picker = picker
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            self.picker.isPresented.wrappedValue.dismiss()
            return
        }
        
        if self.picker.selectedImage.count >= self.picker.maxImageCount {
            
            self.selectedImage = selectedImage
            self.picker.selectedImage.append(self.selectedImage)
            self.picker.isPresented.wrappedValue.dismiss()
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.picker.isPresented.wrappedValue.dismiss()
    }
}


struct CameraView: UIViewControllerRepresentable {
    
    @Binding var selectedImage: [UIImage]
    @Environment(\.presentationMode) var isPresented
    let maxImageCount = 5
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // No updates needed when the UIImagePickerController updates.
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    // Checks if the maximum image count has been reached
    func isImageLimitReached() -> Bool {
        return selectedImage.count >= maxImageCount
    }
    
    // Coordinator class to handle UIImagePickerControllerDelegate methods
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
        var parent: CameraView
        
        init(parent: CameraView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.editedImage] as? UIImage {
                let fixedImage = image.fixOrientation()
                parent.selectedImage.append(fixedImage)
            } else if let image = info[.originalImage] as? UIImage {
                parent.selectedImage.append(image)
            }
            parent.isPresented.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isPresented.wrappedValue.dismiss()
        }
    }
}



import SwiftUI

struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var selectedImages: [UIImage]
    @Environment(\.presentationMode) private var presentationMode
    @Binding var imagesCount: Int?

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary

        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: PhotoPicker

        init(_ parent: PhotoPicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if parent.selectedImages.count < 5 {
                if let pickedImage = info[.editedImage] as? UIImage {
                    let fixedImage = pickedImage.fixOrientation()
                    self.parent.selectedImages.append(fixedImage)
                } else if let originalImage = info[.originalImage] as? UIImage {
                    self.parent.selectedImages.append(originalImage)
                }
                parent.presentationMode.wrappedValue.dismiss()
            }
            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}


struct ImagePickerView: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = context.coordinator
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true // Enable auto-editing
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePickerView
        
        init(_ parent: ImagePickerView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let pickedImage = info[.editedImage] as? UIImage { // Use edited image if available
                parent.selectedImage = pickedImage
            } else if let originalImage = info[.originalImage] as? UIImage {
                parent.selectedImage = originalImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct BorderedImageView: View {
    var image: UIImage
    var borderColor: Color = .blue
    var borderWidth: CGFloat = 5

    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFit()
            .frame(height: 100)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(borderColor, lineWidth: borderWidth)
            )
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}


