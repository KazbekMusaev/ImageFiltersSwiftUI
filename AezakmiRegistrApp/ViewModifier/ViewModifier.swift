//
//  ViewModifier.swift
//  AezakmiRegistrApp
//
//  Created by KazbekMusaev on 13.05.2024.
//

import SwiftUI

struct PlaceholderModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
        .foregroundStyle(.gray)
        .font(.system(size: 20))
    }
}

struct ButtonModifier: ViewModifier {
    let width: CGFloat
    let height: CGFloat
    let opacity: Double
    let cornerRadius: Double
    let shadowRadius: CGFloat
    func body(content: Content) -> some View {
        content
            .font(.title)
            .foregroundStyle(.white)
            .frame(width: width,
                   height: height)
            .background(.white.opacity(opacity))
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .shadow(color: .lightWhite, radius: shadowRadius, x: shadowRadius, y: shadowRadius)
            .shadow(color: .lightWhite, radius: shadowRadius, x: -shadowRadius, y: -shadowRadius)
    }
}
