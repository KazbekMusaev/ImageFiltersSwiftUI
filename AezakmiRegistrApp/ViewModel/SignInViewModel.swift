//
//  ViewModel.swift
//  AezakmiRegistrApp
//
//  Created by KazbekMusaev on 13.05.2024.
//

import SwiftUI

final class SignInViewModel: ObservableObject {
    @Published var isRegirtred: Bool = false
    @Published var isSignIn: Bool = false
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var repeatPassword: String = ""
    @Published var isSecuriteTextInput = true
    @Published var haveAError = false
    @Published var errorMessage = ""
    
    func singIn(_ userData: UserModel) {
        FirebaseServices.shared.signIn(userData) { result in
            switch result {
            case .success(let isSignIn):
                if isSignIn {
                    self.isSignIn = true
                } else {
                    print("Вход не выполнен")
                }
            case .failure(let error):
                print(error.localizedDescription)
                let errorModel = ErrorToRussia()
                let errCode = error as NSError
                var errorRussianString: String {
                    get {
                        let errorStr = errorModel.errorDict[errCode.code]
                        if errorStr == nil {
                            return errorModel.errorDict[0]!
                        } else {
                            return errorStr!
                        }
                    }
                }
                self.errorMessage = errorRussianString
                self.haveAError = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.haveAError = false
                }
            }
        }
    }
    
    func googleSignIn() {
        FirebaseServices.shared.googleSignIn { isAdd in
            if isAdd {
                self.isSignIn = true
            }
        }
    }
    
    func createNewUser() {
        if self.password != self.repeatPassword {
            let errorModel = ErrorToRussia()
            let errorRussianString = errorModel.errorDict[404]!
            self.errorMessage = errorRussianString
            self.haveAError = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.haveAError = false
            }
        } else {
            let userData = UserModel(email: self.email, password: self.password)
            FirebaseServices.shared.createNewUser(userData: userData) { result in
                switch result {
                case .success(let isCreate):
                    print(isCreate)
                case .failure(let error):
                    print(error.localizedDescription)
                    let errorModel = ErrorToRussia()
                    let errCode = error as NSError
                    var errorRussianString: String {
                        get {
                            let errorStr = errorModel.errorDict[errCode.code]
                            if errorStr == nil {
                                return errorModel.errorDict[0]!
                            } else {
                                return errorStr!
                            }
                        }
                    }
                    self.errorMessage = errorRussianString
                    self.haveAError = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.haveAError = false
                    }
                }
            }
        }
    }
    
    
}
