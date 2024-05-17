//
//  FirebaseServices.swift
//  AezakmiRegistrApp
//
//  Created by KazbekMusaev on 13.05.2024.
//

import Foundation
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift
import FirebaseCore

final class FirebaseServices {
    static let shared = FirebaseServices()
    private init() { }
    
    //MARK: Проверка входа
    func checkAuth() -> Bool {
        guard Auth.auth().currentUser != nil else { return false }
        return true
    }
    
    //MARK: Выход
    func signOut() {
        try? Auth.auth().signOut()
    }
    
    //MARK: Регистрация пользователя
    func createNewUser(userData: UserModel, complition: @escaping (Result<Bool, Error>) -> () ) {
        Auth.auth().createUser(withEmail: userData.email, password: userData.password) { res, err in
            guard err == nil else { complition(.failure(err!)) ; return }
            res?.user.sendEmailVerification()
            complition(.success(true))
        }
    }
    
    //MARK: Вход в систему
    func signIn(_ userData: UserModel, complition: @escaping (Result<Bool, Error>) -> ()) {
        Auth.auth().signIn(withEmail: userData.email, password: userData.password) { res, err in
            guard err == nil else {
                complition(.failure(err!))
                return
            }
            complition(.success(true))
        }
    }
    
    //MARK: Вход при помощи гугла
    func googleSignIn(complition: @escaping (Bool) -> () ) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let rootViewController = windowScene.windows.first?.rootViewController else { return }

       
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { userResult, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard let user = userResult?.user else { return }
            guard let idToken = user.idToken else { return }
            let accessToken = user.accessToken
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString,
                                                           accessToken: accessToken.tokenString)
            Auth.auth().signIn(with: credential) { _, error in
                guard error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                complition(true)
            }
        }
    }
    
}



