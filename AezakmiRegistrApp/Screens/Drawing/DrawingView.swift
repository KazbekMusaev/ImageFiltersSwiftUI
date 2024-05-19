//
//  DrawingView.swift
//  AezakmiRegistrApp
//
//  Created by KazbekMusaev on 15.05.2024.
//

import PhotosUI
import StoreKit
import SwiftUI
import PencilKit
import CoreImage
import CoreImage.CIFilterBuiltins

struct DrawingView: View {
    @EnvironmentObject var model: DrawingViewModel
    
    var body: some View {
        ZStack {
            GeometryReader { proxy in
                
                let size = proxy
                
                ZStack {
                    if model.showFilterView {
                        ImageFilter()
                            .environmentObject(model)
                    } else {
                        CanvasView(canvas: $model.canvas,
                                   imageData: $model.imageData,
                                   image: $model.image,
                                   toolPicker: $model.toolPicker,
                                   strokes: $model.strokes,
                                   rect: size.size)
                        .shadow(color: .white,radius: 10)
                    }
                    
                    ForEach(model.textBoxes) { box in
                        Text(model.textBoxes[model.currentIndex].id == box.id && model.addNewBox ? "" : box.text)
                            .font(.system(size: box.textSize))
                            .fontWeight(box.isBold ? .bold : .regular)
                            .foregroundStyle(box.textColor)
                            .offset(box.offset)
                            .gesture(DragGesture().onChanged {
                                let current = $0.translation
                                let lastOffset = box.lastOffset
                                let newTransation = CGSize(width: lastOffset.width + current.width, height: lastOffset.height + current.height)
                                model.textBoxes[getIndex(box)].offset = newTransation
                                
                            }.onEnded {
                                model.textBoxes[getIndex(box)].lastOffset = $0.translation
                            })
                            .onLongPressGesture {
                                model.toolPicker.setVisible(false, forFirstResponder: model.canvas)
                                model.canvas.resignFirstResponder()
                                model.currentIndex = getIndex(box)
                                withAnimation {
                                    model.addNewBox = true
                                }
                            }
                    }
                }
                .onAppear {
                    model.rect = proxy.frame(in: .global)
                }
            }
        }
        .sheet(isPresented: $model.showSharedView) {
            ShareView(image: model.sharedImage)
        }
        .toolbar {
            if !model.strokes.isEmpty {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        NotificationCenter.default.post(name: NSNotification.Name("removeStroke"), object: nil, userInfo: ["removeLast": true])
                        
                    } label: {
                        Image(systemName: "arrowshape.turn.up.backward")
                            .foregroundStyle(.white)
                    }
                }
            }
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    model.shareImage()
                } label: {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundStyle(.white)
                }
            }
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    model.saveImage()
                } label: {
                    Text("save")
                        .foregroundStyle(.white)
                }
            }
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    model.textBoxes.append(TextBox())
                    model.currentIndex = model.textBoxes.count - 1
                    withAnimation {
                        model.addNewBox.toggle()
                    }
                    model.toolPicker.setVisible(false, forFirstResponder: model.canvas)
                    model.canvas.resignFirstResponder()
                } label: {
                    Image(systemName: "plus")
                        .foregroundStyle(.white)
                }
                
            }
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    model.showFilterView.toggle()
                } label: {
                    HStack {
                        Image(systemName: "camera.filters")
                            .foregroundStyle(.white)
                    }
                }
                
            }
        }
    }
    
    func getIndex(_ textBox: TextBox) -> Int {
        let index = model.textBoxes.firstIndex {
            return textBox.id == $0.id
        } ?? 0
        return index
    }
    
}





struct CanvasView: UIViewRepresentable {
    
    func makeCoordinator() -> Coordinator {
        CanvasView.Coordinator(parent: self)
    }
    
    
    @Binding var canvas: PKCanvasView
    @Binding var imageData: Data
    @Binding var image: UIImage
    @Binding var toolPicker: PKToolPicker
    @Binding var strokes: [PKStroke]
    
    var rect: CGSize
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvas.delegate = context.coordinator
        canvas.isOpaque = false
        canvas.backgroundColor = .clear
        canvas.drawingPolicy = .anyInput
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("removeStroke"), object: nil, queue: nil) { not in
            if let isRemove = not.userInfo?["removeLast"] as? Bool {
                if isRemove {
                    removeLastStroke()
                }
            }
        }
        
        func removeLastStroke() {
            if canvas.drawing.strokes.isEmpty {
            } else {
                canvas.drawing.strokes.removeLast()
            }
            
        }
        
        if image == UIImage(resource: .aezakmi) {
            if let image = UIImage(data: imageData) {
                let imageView = UIImageView(image: image)
                imageView.frame = CGRect(origin: .zero, size: rect)
                imageView.contentMode = .scaleAspectFit
                imageView.clipsToBounds = true
                
                let subView = canvas.subviews[0]
                subView.addSubview(imageView)
                subView.sendSubviewToBack(imageView)
                
                toolPicker.setVisible(true, forFirstResponder: canvas)
                toolPicker.addObserver(canvas)
                canvas.becomeFirstResponder()
            }
        } else {
            let imageView = UIImageView(image: image)
            imageView.frame = CGRect(origin: .zero, size: rect)
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            
            let subView = canvas.subviews[0]
            subView.addSubview(imageView)
            subView.sendSubviewToBack(imageView)
            
            toolPicker.setVisible(true, forFirstResponder: canvas)
            toolPicker.addObserver(canvas)
            canvas.becomeFirstResponder()
        }
        
        
        
        
        return canvas
    }
    
    
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        
    }
    
    class Coordinator: NSObject, PKCanvasViewDelegate {
        var parent: CanvasView
        
        init(parent: CanvasView) {
            self.parent = parent
        }
        
        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            parent.strokes = canvasView.drawing.strokes
        }
        
    }
    
}
