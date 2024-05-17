//
//  ProfileView.swift
//  AezakmiRegistrApp
//
//  Created by KazbekMusaev on 14.05.2024.
//

import SwiftUI

struct ProfileView: View {
    @Binding var isSign: Bool
    var body: some View {
        ZStack {
            LinearGradient(colors: [.backStartPoint, .backLastPoint], startPoint: .topTrailing, endPoint: .bottomLeading)
                .ignoresSafeArea()
            Button {
                FirebaseServices.shared.signOut()
                isSign = false
            } label: {
                Text("SignOut")
                    .padding(.vertical, 5)
                    .padding(.horizontal, 10)
                    .buttonModifier(widht: 120,
                                    height: 44,
                                    opacity: 0.1,
                                    cornerRadius: 12,
                                    shadowRadius: 8)
            }
        }
    }
}

#Preview {
    ProfileView(isSign: .constant(true))
}
