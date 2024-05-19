//
//  ImageFilter.swift
//  AezakmiRegistrApp
//
//  Created by KazbekMusaev on 17.05.2024.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import PhotosUI
import StoreKit
import SwiftUI

struct ImageFilter: View {
    @EnvironmentObject var model: DrawingViewModel
    
    var body: some View {
        if model.useImageData {
            NavigationStack {
                VStack {
                    Spacer()
                    if let cameraImage = model.cameraImage  {
                        cameraImage
                            .resizable()
                            .scaledToFit()
                    }
                    Spacer()

                    HStack {
                        Text("Intensity")
                        if #available(iOS 17.0, *) {
                            Slider(value: $model.filterIntensity)
                                .onChange(of: model.filterIntensity) {
                                    model.applyProcessing()
                                }
                        } else {
                            // Fallback on earlier versions
                        }
                        Button {
                            model.showFilterView.toggle()
                            model.applyProcessing()
                        } label: {
                            Text("Ok")
                                .foregroundStyle(.white)
                        }

                    }

                    HStack {
                        Button("Change Filter", action: changeFilter)

                        Spacer()
                    }
                }
                .padding([.horizontal, .bottom])
                .navigationTitle("Use Filter")
                .confirmationDialog("Select a filter", isPresented: $model.showingFilters) {
                    Button("Crystallize") { setFilter(CIFilter.crystallize() )}
                    Button("Edges") { setFilter(CIFilter.edges() )}
                    Button("Gaussian Blur") { setFilter(CIFilter.gaussianBlur() )}
                    Button("Pixellate") { setFilter(CIFilter.pixellate() )}
                    Button("Sepia Tone") { setFilter(CIFilter.sepiaTone() )}
                    Button("Unsharp Mask") { setFilter(CIFilter.unsharpMask() )}
                    Button("Vignette") { setFilter(CIFilter.vignette() )}
                    Button("Cancel", role: .cancel) { }
                }
            }
        } else {
            NavigationStack {
                VStack {
                    Spacer()
                    if let processedImage = model.processedImage {
                        processedImage
                            .resizable()
                            .scaledToFit()
                    }
                    Spacer()

                    HStack {
                        Text("Intensity")
                        if #available(iOS 17.0, *) {
                            Slider(value: $model.filterIntensity)
                                .onChange(of: model.filterIntensity) {
                                    model.applyProcessing()
                                }
                        } else {
                            // Fallback on earlier versions
                        }
                        Button {
                            model.processedImage = nil
                            model.showFilterView.toggle()
                            model.applyProcessing()
                        } label: {
                            Text("Ok")
                                .foregroundStyle(.white)
                        }

                    }

                    HStack {
                        Button("Change Filter", action: changeFilter)

                        Spacer()
                    }
                }
                .padding([.horizontal, .bottom])
                .navigationTitle("Use Filter")
                .confirmationDialog("Select a filter", isPresented: $model.showingFilters) {
                    Button("Crystallize") { setFilter(CIFilter.crystallize() )}
                    Button("Edges") { setFilter(CIFilter.edges() )}
                    Button("Gaussian Blur") { setFilter(CIFilter.gaussianBlur() )}
                    Button("Pixellate") { setFilter(CIFilter.pixellate() )}
                    Button("Sepia Tone") { setFilter(CIFilter.sepiaTone() )}
                    Button("Unsharp Mask") { setFilter(CIFilter.unsharpMask() )}
                    Button("Vignette") { setFilter(CIFilter.vignette() )}
                    Button("Cancel", role: .cancel) { }
                }
            }
        }
    }

    func changeFilter() {
        model.showingFilters = true
    }

    @MainActor func setFilter(_ filter: CIFilter) {
        model.currentFilter = filter
        model.loadImage()

        model.filterCount += 1

        if model.filterCount >= 20 {
            model.requestReview()
        }
    }
}

