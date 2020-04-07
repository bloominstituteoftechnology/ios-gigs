//
//  LoginViewModel.swift
//  Gigs
//
//  Created by Nichole Davidson on 4/7/20.
//  Copyright © 2020 Nichole Davidson. All rights reserved.
//

import Foundation
final class LoginViewModel {
    enum LoginResult: String {
        case signUpSuccess = "Sign up successful. Now please log in."
        case loginSuccess
        case signUpError = "Error occurred during sign up."
        case loginError = "Error occurred during log in."
    }
    
    private let gigController: GigController
    
    init(gigController: GigController = GigController()) {
        self.gigController = gigController
    }
    
    func submit(with user: User, forLoginType loginType: LoginType, completion: @escaping (LoginResult) -> Void) {
        switch loginType {
       
        case .signUp:
            signUp(with: user, completion: completion)
        case .login:
            login(with: user, completion: completion)
        }
    }
    
    private func signUp(with user: User, completion: @escaping (LoginResult) -> Void) {
        gigController.signUp(with: user) { (result) in
            switch result {
            case .success(_):
                completion(.signUpSuccess)
            case .failure(_):
                completion(.signUpError)
            }
        }
    }
    
    private func login(with user: User, completion: @escaping (LoginResult) -> Void) {
        gigController.login(with: user) { (result) in
            switch result {
            case .success(_):
                completion(.loginSuccess)
            case .failure(_):
                completion(.loginError)
            }
        }
    }
}
