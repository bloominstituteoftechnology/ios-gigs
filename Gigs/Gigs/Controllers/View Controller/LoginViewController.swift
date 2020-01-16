//
//  LoginViewController.swift
//  Gigs
//
//  Created by Tobi Kuyoro on 15/01/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case signIn
}

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    var loginType = LoginType.signUp
    var gigController: GigController?
    
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginTypeSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var signInButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signInButton.backgroundColor = UIColor(hue: 190/360, saturation: 70/100, brightness: 80/100, alpha: 1.0)
        signInButton.tintColor = .white
        signInButton.layer.cornerRadius = 8.0
    }
    
    @IBAction func logInTypeChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            loginType = .signUp
            signInButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .signIn
            signInButton.setTitle("Sign In", for: .normal)
        }
    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        guard let gigController = gigController,
            let username = usernameTextField.text,
            let password = passwordTextField.text,
            username != "",
            !password.isEmpty else { return }
        
        let user = User(username: username, password: password)
        print(user)
        
        if loginType == .signUp {
            gigController.signUp(with: user) { (error) in
                if let error = error {
                    NSLog("Error signing up: \(error)")
                } else {
                    let alert = UIAlertController(title: "Sign Up Successful",
                                                  message: "Now please log in",
                                                  preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(action)
                    
                    DispatchQueue.main.async {
                        self.present(alert, animated: true) {
                            self.loginType = .signIn
                            self.loginTypeSegmentedControl.selectedSegmentIndex = 1
                            self.signInButton.setTitle("Sign In", for: .normal)
                        }
                    }
                }
            }
        } else {
            gigController.signIn(with: user) { (error) in
                if let error = error {
                    NSLog("Error signing in: \(error)")
                } else {
                    DispatchQueue.main.sync {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
   
}
