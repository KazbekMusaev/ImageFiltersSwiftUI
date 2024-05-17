//
//  DrawingViewModel.swift
//  AezakmiRegistrApp
//
//  Created by KazbekMusaev on 15.05.2024.
//

import SwiftUI
import PencilKit
import PhotosUI

final class DrawingViewModel: ObservableObject {
    @Published var showImagePicker: Bool = false
    @Published var imageData: Data = Data()
    @Published var canvas = PKCanvasView()
    @Published var toolPicker = PKToolPicker()
    @Published var textBoxes = [TextBox]()
    @Published var addNewBox: Bool = false
    @Published var currentIndex: Int = 0
    @Published var strokes: [PKStroke] = []
    @Published var rect: CGRect = .zero
    @Published var showAlert: Bool = false
    @Published var message = String()
    @Published var presentShareLink = false
    @Published var sharedImage = UIImage()
    @Published var showSharedView = false
    
    @Published var useImageData: Bool = false
    
    //Filtres
    @Published var showFilterView: Bool = false
    @Published var image = UIImage(resource: .aezakmi)
    @Published var processedImage: Image?
    @Published var filterIntensity = 0.0
    @Published var selectedItem: PhotosPickerItem?
    @Published var showingFilters = false
    @Published var currentFilter: CIFilter = CIFilter.sepiaTone()
    @AppStorage("filterCount") var filterCount = 0
    @Environment(\.requestReview) var requestReview
    
    
    func cancelImageEditor() {
        imageData = Data(count: 0)
        canvas = PKCanvasView()
        textBoxes.removeAll()
        useImageData = false
        processedImage = nil
        image = UIImage(resource: .aezakmi)
        selectedItem = nil
        filterIntensity = 0.0
    }
    
    func cancelTextView() {
        toolPicker.setVisible(true, forFirstResponder: canvas)
        canvas.becomeFirstResponder()
        withAnimation {
            addNewBox = false
        }
        if !textBoxes[currentIndex].isAdded {
            textBoxes.removeLast()
        }
    }
    
    private func imageRendering() -> Data {
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        
        canvas.drawHierarchy(in: CGRect(origin: .zero, size: rect.size), afterScreenUpdates: true)
        
        let swiftUIView = ZStack {
            ForEach(textBoxes) { [self] box in
                Text(textBoxes[currentIndex].id == box.id && addNewBox ? "" : box.text)
                    .font(.system(size: box.textSize))
                    .fontWeight(box.isBold ? .bold : .regular)
                    .foregroundStyle(box.textColor)
                    .offset(box.offset)
                    .background(.clear)
            }
        }
        
        let conrtoller = UIHostingController(rootView: swiftUIView).view!
        conrtoller.frame = rect
        conrtoller.backgroundColor = .clear
        conrtoller.drawHierarchy(in: CGRect(origin: .zero, size: rect.size), afterScreenUpdates: true)
        
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        guard let image = image?.pngData() else { return Data() }
        return image
    }
    
    func saveImage() {
        let imgData = imageRendering()
        if !imgData.isEmpty {
            UIImageWriteToSavedPhotosAlbum(UIImage(data: imgData)!, nil, nil, nil)
            print("succes")
            self.message = "Saved Success"
            self.showAlert.toggle()
        }
    }
    
    func shareImage() {
        let imgData = imageRendering()
        let imageUI = UIImage(data: imgData)!
        self.showSharedView.toggle()
        self.sharedImage = imageUI
    }
    
    func loadImage() {
        Task {
            guard let imageData = try await selectedItem?.loadTransferable(type: Data.self) else { return }
            guard let inputImage = UIImage(data: imageData) else { return }

            let beginImage = CIImage(image: inputImage)
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
            applyProcessing()
        }
    }
    
    func applyProcessing(_ setFilters: Bool = false) {
        self.image = UIImage(resource: .aezakmi)
        let inputKeys = currentFilter.inputKeys

        if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey) }
        if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(filterIntensity * 200, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(filterIntensity * 10, forKey: kCIInputScaleKey) }

        guard let outputImage = currentFilter.outputImage else { return }
        guard let cgImage = CIContext().createCGImage(outputImage, from: outputImage.extent) else { return }

        let uiImage = UIImage(cgImage: cgImage)
        self.image = uiImage
        processedImage = Image(uiImage: uiImage)
    }
    
}
