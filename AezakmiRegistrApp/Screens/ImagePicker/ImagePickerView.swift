//
//  ImagePickerView.swift
//  AezakmiRegistrApp
//
//  Created by KazbekMusaev on 15.05.2024.
//

import SwiftUI
import PhotosUI

struct ImagePickerView: View {
    @StateObject private var model = DrawingViewModel()
    
    var body: some View {
        ZStack {
            NavigationStack {
                GeometryReader { proxy in
                    ZStack {
                        LinearGradient(colors: [.backStartPoint, .backLastPoint], startPoint: .topLeading, endPoint: .bottomTrailing)
                            .ignoresSafeArea()
                        VStack {
                            if model.image == UIImage(resource: .aezakmi) {
                                if UIImage(data: model.imageData) == nil {
                                    PhotosPicker(selection: $model.selectedItem) {
                                        if let processedImage = model.processedImage {
                                            processedImage
                                                .resizable()
                                                .scaledToFit()
                                        } else {
                                            Image(systemName: "photo.stack.fill")
                                                .buttonModifier(widht: proxy.size.width - 20,
                                                                height: 200,
                                                                opacity: 0.09,
                                                                cornerRadius: 12,
                                                                shadowRadius: 5)
                                        }
                                    }
                                    .onChange(of: model.selectedItem, model.loadImage)
                                }
                            }
                            if let _ = UIImage(data: model.imageData) {
                                DrawingView()
                                    .environmentObject(model)
                                    .toolbar {
                                        Button {
                                            model.cancelImageEditor()
                                        } label: {
                                            Image(systemName: "xmark")
                                                .foregroundStyle(.white)
                                        }
                                    }
                            } else if model.processedImage != nil {
                                DrawingView()
                                    .environmentObject(model)
                                    .toolbar {
                                        Button {
                                            model.processedImage = nil
                                            model.image = UIImage(resource: .aezakmi)
                                            model.selectedItem = nil
                                            model.cancelImageEditor()
                                        } label: {
                                            Image(systemName: "xmark")
                                                .foregroundStyle(.white)
                                        }
                                    }
                            } else {
                                Button {
                                    model.showImagePicker.toggle()
                                } label: {
                                    Image(systemName: "camera")
                                        .buttonModifier(widht: proxy.size.width - 20,
                                                        height: 200,
                                                        opacity: 0.09,
                                                        cornerRadius: 12,
                                                        shadowRadius: 5)
                                }
                            }
                        }
                        .navigationTitle("Image Editor")
                    }
                }
            }
            if model.addNewBox {
                Color.white.opacity(0.3)
                    .ignoresSafeArea()
                TextField(text: $model.textBoxes[model.currentIndex].text) {
                    Text("Enter text")
                        .foregroundStyle(.black)
                }
                .font(.system(size: model.textBoxes[model.currentIndex].textSize, weight: model.textBoxes[model.currentIndex].isBold ? .bold : .regular))
                .preferredColorScheme(.light)
                .foregroundStyle(model.textBoxes[model.currentIndex].textColor)
                .padding()
                
                VStack {
                    HStack {
                        Button {
                            model.textBoxes[model.currentIndex].isAdded = true
                            model.toolPicker.setVisible(true, forFirstResponder: model.canvas)
                            model.canvas.becomeFirstResponder()
                            withAnimation {
                                model.addNewBox = false
                            }
                        } label: {
                            Text("Add")
                                .font(.title2)
                                .bold()
                                .foregroundStyle(.white)
                                .padding(.all, 10)
                                .background(.black)
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                        }
                        Spacer()
                        Button {
                            model.cancelTextView()
                        } label: {
                            Text("Cancel")
                                .font(.title2)
                                .bold()
                                .foregroundStyle(.white)
                                .padding(.all, 10)
                                .background(.black)
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                        }
                    }
                    .overlay {
                        HStack(spacing: 15) {
                            ColorPicker("", selection: $model.textBoxes[model.currentIndex].textColor)
                                .labelsHidden()
                            
                            Button {
                                model.textBoxes[model.currentIndex].isBold.toggle()
                            } label: {
                                Text(model.textBoxes[model.currentIndex].isBold ? "Regular" : "Bold")
                                    .fontWeight(.bold)
                                    .foregroundStyle(.black)
                            }
                            
                        }
                    }
                    .frame(maxHeight: .infinity, alignment: .top)
                    Spacer()
                    Slider(value: $model.textBoxes[model.currentIndex].textSize, in: (20...50))
                        .padding()
                }
                
            }
        }
        .sheet(isPresented: $model.showImagePicker) {
            ImagePickerBuild(showPicker: $model.showImagePicker, 
                             image: $model.image,
                             imageData: $model.imageData)
        }
        .alert(Text(model.message), isPresented: $model.showAlert, presenting: String()) { mess in
            Button("Ok", role: .cancel) { }
        }
    }
}

#Preview {
    ImagePickerView()
}
