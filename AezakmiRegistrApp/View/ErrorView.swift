//
//  ErrorView.swift
//  AezakmiRegistrApp
//
//  Created by KazbekMusaev on 14.05.2024.
//

import SwiftUI

struct ErrorView: View {
    let errorMessage: String
    var body: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(.black)
            Text(errorMessage)
                .scaledToFit()
                .minimumScaleFactor(0.6)
                .foregroundStyle(.red)
        }
            .padding()
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(lineWidth: 2)
                    .foregroundStyle(.red)
            }
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            
            
    }
}

#Preview {
    ErrorView(errorMessage: "Слишком много попыток входа, повторите через 30 секунд")
}
