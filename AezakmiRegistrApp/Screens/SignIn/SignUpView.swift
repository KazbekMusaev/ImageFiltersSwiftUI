//
//  SignUpView.swift
//  AezakmiRegistrApp
//
//  Created by KazbekMusaev on 14.05.2024.
//

import SwiftUI

struct SignUpView: View {
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
                Text("Registration")
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
                    
                    SecuriteTextField(isSecuriteTextInput: $model.isSecuriteTextInput,
                                      password: $model.repeatPassword,
                                      placeholder: "Password confirm")
                    
                    Divider()
                        .background(.white)
                    
                }
                .padding(.top, 50)
                
                
                Button {
                    model.createNewUser()
                } label: {
                    Text("Create Account")
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .changeTextColor(model.email.isEmpty || model.password.isEmpty)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.vertical, 15)
                .disableButtonWhen(model.email.isEmpty || model.password.isEmpty)
                
                Spacer()
                
            }
            .padding()
            
        }
    }
}

#Preview {
    SignUpView()
}
