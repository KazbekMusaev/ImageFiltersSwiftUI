//
//  TabBar.swift
//  AezakmiRegistrApp
//
//  Created by KazbekMusaev on 14.05.2024.
//

import SwiftUI

struct TabBar: View {
    @State private var selectedTag = 1
    @Binding var isSign: Bool
    var body: some View {
        TabView(selection: $selectedTag) {
            ImagePickerView()
                .tabItem {
                    Image(systemName: "photo.fill")
                        .foregroundStyle(.white)
                    Text("Главная")
                }
                .tag(1)
                
            ProfileView(isSign: $isSign)
                .tabItem {
                    Image(systemName: "person")
                    Text("Профиль")
                }
                .tag(2)
        }
    }
}

#Preview {
    TabBar(isSign: .constant(true))
}
