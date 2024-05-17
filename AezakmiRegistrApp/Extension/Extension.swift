//
//  Extension.swift
//  AezakmiRegistrApp
//
//  Created by KazbekMusaev on 13.05.2024.
//

import SwiftUI

extension View {
    func placeholderModifier() -> some View {
        modifier(PlaceholderModifier())
    }
}

extension View {
    func disableButtonWhen(_ condition: Bool) -> some View {
        self
            .disabled(condition)
            .foregroundStyle(condition ? .gray : .white)
    }
}

extension View {
    func changeTextColor(_ condition: Bool) -> some View {
        self
            .background(condition ? .gray : .white)
    }
}

extension View {
    func buttonModifier(widht: CGFloat, height: CGFloat, opacity: Double, cornerRadius: Double, shadowRadius: CGFloat) -> some View {
        modifier(ButtonModifier(width: widht,
                                height: height,
                                opacity: opacity,
                                cornerRadius: cornerRadius,
                                shadowRadius: shadowRadius))
    }
}

extension Image {
    @MainActor
    func getUIImage(newSize: CGSize) -> UIImage? {
        let image = resizable()
            .scaledToFill()
            .frame(width: newSize.width, height: newSize.height)
            .clipped()
        return ImageRenderer(content: image).uiImage
    }
}
