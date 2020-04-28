//
//  LoginViewController.swift
//  Gigs
//
//  Created by Joseph Rogers on 11/4/19.
//  Copyright © 2019 Joseph Rogers. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case signIn
}

class LoginViewController: UIViewController {
    
    @IBOutlet private weak var usernameTextField: UITextField!
       @IBOutlet private weak var passwordTextField: UITextField!
       @IBOutlet private weak var loginTypeSegmentedControl: UISegmentedControl!
       @IBOutlet private weak var signInButton: UIButton!
    
    var gigController: GigController?
        var loginType = LoginType.signUp

        override func viewDidLoad() {
            super.viewDidLoad()

            signInButton.backgroundColor = UIColor(hue: 190/360, saturation: 70/100, brightness: 80/100, alpha: 1.0)
                signInButton.tintColor = .white
                signInButton.layer.cornerRadius = 8.0
        }
        
        // MARK: - Action Handlers
        
        @IBAction func buttonTapped(_ sender: UIButton) {
            // perform login or sign up operation based on loginType
            //access api controller.
            guard let apiController = gigController else {return}
            if let username = usernameTextField.text,
                !username.isEmpty,
                let password = passwordTextField.text,
                !password.isEmpty {
                //creating the new user
                let user = User(username: username, password: password)
                //sign up the user
                if loginType == .signUp {
                    apiController.signUp(with: user) { error in
                        if let error = error {
                            print("Error occured during sign up: \(error)")
                        } else {
                            DispatchQueue.main.async {
                                let alertController = UIAlertController(title: "Sign up Successful", message: "Now please log in.", preferredStyle: .alert)
                                let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                                alertController.addAction(alertAction)
                                self.present(alertController, animated: true) {
                                    self.loginType = .signIn
                                    self.loginTypeSegmentedControl.selectedSegmentIndex = 1
                                    self.signInButton.setTitle("Sign In", for: .normal)
                                }
                            }
                            
                        }
                    }
                } else {
                    //run sign in api call
                    apiController.signIn(with: user) { error in
                        if let error = error {
                            print("Error occured during sign up \(error)")
                        } else {
                            DispatchQueue.main.async {
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
        }
        
        @IBAction func signInTypeChanged(_ sender: UISegmentedControl) {
            // switch UI between login types
            if sender.selectedSegmentIndex == 0 {
                loginType = .signUp
                signInButton.setTitle("Sign Up", for: .normal)
            } else {
                loginType = .signIn
                signInButton.setTitle("Sign In", for: .normal)
            }
        }
    }
