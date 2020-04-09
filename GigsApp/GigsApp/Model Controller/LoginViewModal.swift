//
//  LoginViewModel.swift
//  AnimalSpotter
//
//  Created by Bhawnish Kumar on 4/7/20.
//  Copyright © 2020 Scott Gardner. All rights reserved.
//

import Foundation

final class LoginViewModel {
    enum LoginResult: String {
        case signUpSuccess = "Sign up successfulll Now please log in."
        case signInSuccess
        case signUpError = "Error occured during sign up."
        case signInError = "Error occured during sign in."
    }
    private let gigController: GigController
    
    init(gigController: GigController = GigController()) {
        self.gigController = gigController
    }
    
    func submit(with user: User, forLoginType loginType: LoginType, completion: @escaping (LoginResult) -> Void) {
        switch loginType {
        case .signUp:
            signUp(with: user, completion: completion)
        default:
            signIn(with: user, completion: completion)
        }
    }
    
    private func signUp(with user: User, completion: @escaping (LoginResult) -> Void) {
        gigController.signUp(with: user) { result in
            switch result {
            case .success(_):
                completion(.signUpSuccess)
            case .failure(_):
                completion(.signUpError)
                
            }
    }
}
    private func signIn(with user: User, completion: @escaping (LoginResult) -> Void) {
        gigController.signIn(with: user) { result in
            switch result {
            case .success(_):
                completion(.signInSuccess)
            case .failure(_):
                completion(.signUpError)
            }
        }
     }
    
}
