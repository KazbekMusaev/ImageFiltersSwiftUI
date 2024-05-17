//
//  TextBox.swift
//  AezakmiRegistrApp
//
//  Created by KazbekMusaev on 15.05.2024.
//

import SwiftUI
import PencilKit

struct TextBox: Identifiable {
    var id = UUID().uuidString
    var text: String = ""
    var isBold: Bool = false
    var offset: CGSize = .zero
    var lastOffset: CGSize = .zero
    var textColor: Color = .black
    var textSize: CGFloat = 20
    var isAdded: Bool = false
}
