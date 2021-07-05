//
//  LoginViewController.swift
//  Gigs
//
//  Created by Jeremy Taylor on 5/16/19.
//  Copyright © 2019 Bytes-Random L.L.C. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    enum LoginType {
        case signUp
        case signIn
    }
    
    @IBOutlet weak var loginTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginTypeButton: UIButton!
    
    var gigController: GigController!
    var loginType = LoginType.signUp
    
    @IBAction func loginTypeValueChanged(_ sender: Any) {
        if loginTypeSegmentedControl.selectedSegmentIndex == 0 {
            loginType = .signUp
            loginTypeButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .signIn
            loginTypeButton.setTitle("Sign In", for: .normal)
        }
    }
    
    @IBAction func loginTypeButtonTapped(_ sender: Any) {
        guard let username = usernameTextField.text,
            !username.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty else { return }
        
        let user = User(username: username, password: password)
        
        if loginType == .signUp {
            gigController.signUp(with: user.username, password: user.password) { (error) in
                if let error = error {
                    NSLog("Error occurred during sign up: \(error)")
                } else {
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: "Sign Up Successful", message: "Now please log in.", preferredStyle: .alert)
                        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(alertAction)
                        self.present(alertController, animated: true, completion: {
                            self.loginType = .signIn
                            self.loginTypeSegmentedControl.selectedSegmentIndex = 1
                            self.loginTypeButton.setTitle("Sign In", for: .normal)
                        })
                    }
                }
            }
        } else {
            gigController.logIn(with: user.username, password: user.password) { (error) in
                if let error = error {
                    NSLog("Error occured during sign in: \(error)")
                } else {
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
}
