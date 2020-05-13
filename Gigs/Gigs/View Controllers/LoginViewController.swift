//
//  LoginViewController.swift
//  Gigs
//
//  Created by Bronson Mullens on 5/11/20.
//  Copyright © 2020 Bronson Mullens. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var signUpSignInControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpSignInButton: UIButton!
    
    // MARK: - IBActions
    @IBAction func signSegmentedTapped(_ sender: Any) {
        if signUpSignInControl.selectedSegmentIndex == 0 {
            loginType = .signUp
            signUpSignInButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .signIn
            signUpSignInButton.setTitle("Sign In", for: .normal)
        }
    }
    
    @IBAction func signButtonTapped(_ sender: Any) {
        if let username = usernameTextField.text, !username.isEmpty,
            let password = passwordTextField.text, !password.isEmpty {
            let user = User(username: username, password: password)
            if loginType == .signUp {
                gigController?.signUp(with: user, completion: { (result) in
                    do {
                        let success = try result.get()
                        if success {
                            DispatchQueue.main.async {
                                let alertController = UIAlertController(title: "Sign Up Successful", message: "Please log in", preferredStyle: .alert)
                                let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                alertController.addAction(alertAction)
                                self.present(alertController, animated: true) {
                                    self.loginType = .signIn
                                    self.signUpSignInControl.selectedSegmentIndex = 1
                                    self.signUpSignInButton.setTitle("Sign In", for: .normal)
                                }
                            }
                        }
                    } catch {
                        NSLog("Error signing up: \(error)")
                    }
                })
            } else {
                gigController?.signIn(with: user, completion: { (result) in
                    do {
                        let success = try result.get()
                        if success {
                            DispatchQueue.main.async {
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                    } catch {
                        if let error = error as? GigController.NetworkError {
                            switch error {
                            case .failedSignIn:
                                NSLog("Sign in failed")
                            case .noToken, .noData:
                                NSLog("No data received")
                            default:
                                NSLog("Unknown error occured")
                            }
                        }
                    }
                })
            }
        }
    }
    
    // MARK: - Properties
    var gigController: GigController?
    var loginType: LoginType = .signUp
    
    enum LoginType {
        case signUp
        case signIn
    }
    
}
