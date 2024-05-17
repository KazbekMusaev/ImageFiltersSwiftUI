//
//  ImagePickerBuild.swift
//  AezakmiRegistrApp
//
//  Created by KazbekMusaev on 15.05.2024.
//

import SwiftUI

struct ImagePickerBuild: UIViewControllerRepresentable{
    
    @Binding var showPicker: Bool
    @Binding var image: UIImage
    @Binding var imageData: Data
    
    func makeCoordinator() -> Coordinator {
        ImagePickerBuild.Coordinator(parent: self)
    }
 
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let controller = UIImagePickerController()
        controller.sourceType = .camera
        controller.delegate = context.coordinator
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        ()
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePickerBuild
        
        init(parent: ImagePickerBuild) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let imageData = (info[.originalImage] as? UIImage)?.pngData() {
                guard let image = UIImage(data: imageData) else { return }
                parent.imageData = imageData
                parent.image = image
                parent.showPicker.toggle()
            }
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.showPicker.toggle()
        }
    }
}


