//
//  LoginViewController.swift
//  Gigs
//
//  Created by Enrique Gongora on 2/12/20.
//  Copyright © 2020 Enrique Gongora. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case signIn
}

class LoginViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var signInButton: UIButton!
    
    //MARK: - Variables
    var gigController: GigController!
    var loginType = LoginType.signUp
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - IBActions
    @IBAction func signInTypeChanged(_ sender: UISegmentedControl) {
        // Switch UI between login types
        if sender.selectedSegmentIndex == 0 {
            loginType = .signUp
            signInButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .signIn
            signInButton.setTitle("Sign in", for: .normal)
        }
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        
        // Unwrap the GigController
        guard let gigController = gigController else { return }
        
        // Collect user content (username, password)
        if let username = usernameTextField.text, !username.isEmpty, let password = passwordTextField.text, !password.isEmpty {
            let user = User(username: username, password: password)
            
            // Determine which mode to use
            if loginType == .signUp {
                gigController.signUp(with: user) { (error) in
                    if let error = error {
                        NSLog("Error occured during sign up: \(error)")
                    } else {
                        DispatchQueue.main.async {
                            let alertController = UIAlertController(title: "Sign Up Successful", message: "Now please log in.", preferredStyle: .alert)
                            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
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
                gigController.signIn(with: user) { (error) in
                    if let error = error {
                        NSLog("Error occured during sign up: \(error)")
                    } else {
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
}
