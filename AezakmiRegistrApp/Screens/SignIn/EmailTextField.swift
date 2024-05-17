//
//  EmailTextField.swift
//  AezakmiRegistrApp
//
//  Created by KazbekMusaev on 14.05.2024.
//

import SwiftUI

struct EmailTextField: View {
    @Binding var email: String
    var body: some View {
        HStack(spacing: 15){
            Text("@")
                .font(.system(size: 24))
            TextField(text: $email) {
                Text("Email")
                    .placeholderModifier()
            }
            .foregroundStyle(.white)
        }
        .foregroundStyle(.white)
    }
}
