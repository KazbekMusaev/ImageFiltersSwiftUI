//
//  LogoImage.swift
//  AezakmiRegistrApp
//
//  Created by KazbekMusaev on 14.05.2024.
//

import SwiftUI

struct LogoImage: View {
    var body: some View {
        Image(.aezakmi)
            .resizable()
            .frame(height: 200)
            .aspectRatio(contentMode: .fit)
            .zIndex(1)
    }
}
