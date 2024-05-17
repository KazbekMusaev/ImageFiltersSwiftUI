//
//  ContentView.swift
//  AezakmiRegistrApp
//
//  Created by KazbekMusaev on 13.05.2024.
//

import SwiftUI

struct SignInView: View {
    @StateObject var model = SignInViewModel()
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.backStartPoint, .backLastPoint], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            if model.haveAError {
                ErrorView(errorMessage: model.errorMessage)
                    .zIndex(2)
                    .frame(maxHeight: .infinity, alignment: .top)
            }
            VStack {
                LogoImage()
                Text("Login")
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 30, weight: .bold))
                    .padding(.top, 20)
                
                VStack {
                    EmailTextField(email: $model.email)
                    
                    Divider()
                        .background(.white)
                    
                    SecuriteTextField(isSecuriteTextInput: $model.isSecuriteTextInput,
                                      password: $model.password)
                    
                    Divider()
                        .background(.white)
                    
                    Button {
                        print("forgot password")
                    } label: {
                        Text("Forgot your password? ")
                            .foregroundStyle(.white)
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(.top, 50)
                
                Button {
                    let userData = UserModel(email: model.email,
                                             password: model.password)
                    model.singIn(userData)
                } label: {
                    Text("Login")
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .changeTextColor(model.email.isEmpty || model.password.isEmpty)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.vertical, 15)
                .disableButtonWhen(model.email.isEmpty || model.password.isEmpty)
                
                HStack {
                    VStack {
                        Divider()
                            .background(.white)
                    }
                    Text("or")
                        .foregroundStyle(.white)
                    VStack {
                        Divider()
                            .background(.white)
                    }
                }
                
                Button {
                    model.googleSignIn()
                } label: {
                    HStack {
                        Image(.google)
                            .resizable()
                            .frame(width: 30,height: 30)
                        Text("sign in with Google")
                            .foregroundStyle(.blue)
                            .bold()
                    }
                    
                }
                .buttonStyle(.bordered)
                
                Spacer()
                
                HStack {
                    Text("Don't have an account ? ")
                        .foregroundStyle(.white)
                    NavigationLink {
                        SignUpView(model: model)
                    } label: {
                        Text("Sign up")
                            .foregroundStyle(.blue)
                            .bold()
                    }
                }
                
                Spacer()
                
            }
            .padding()
        }

    }
    
}

