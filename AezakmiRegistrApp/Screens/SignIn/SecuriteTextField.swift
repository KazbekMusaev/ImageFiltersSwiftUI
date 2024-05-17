//
//  SecuriteTextField.swift
//  AezakmiRegistrApp
//
//  Created by KazbekMusaev on 14.05.2024.
//

import SwiftUI

struct SecuriteTextField: View {
    @Binding var isSecuriteTextInput: Bool
    @Binding var password: String
    var placeholder: String = "Password"
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: "lock")
                .resizable()
                .frame(width: 20, height: 24)
                .aspectRatio(contentMode: .fit)
            if isSecuriteTextInput {
                SecureField(text: $password) {
                    Text(placeholder)
                        .placeholderModifier()
                }
                .foregroundStyle(.white)
            } else {
                TextField(text: $password) {
                    Text(placeholder)
                        .placeholderModifier()
                }
                .foregroundStyle(.white)
            }
            
            Button {
                isSecuriteTextInput.toggle()
            } label: {
                Image(systemName: "eye")
            }

            
        }
        .foregroundStyle(.white)
        .padding(.vertical, 5)
    }
}

