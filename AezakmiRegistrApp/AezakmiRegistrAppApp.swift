//
//  AezakmiRegistrAppApp.swift
//  AezakmiRegistrApp
//
//  Created by KazbekMusaev on 13.05.2024.
//

import SwiftUI

@main
struct AezakmiRegistrAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @ObservedObject private var viewModel = SignInViewModel()
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if viewModel.isSignIn {
                    TabBar(isSign: $viewModel.isSignIn)
                } else {
                    SignInView(model: viewModel)
                }
            }
            .onAppear {
                viewModel.isSignIn = FirebaseServices.shared.checkAuth()
            }
        }
    }
}

