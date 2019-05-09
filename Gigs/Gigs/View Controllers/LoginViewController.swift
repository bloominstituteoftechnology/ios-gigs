//
//  LoginViewController.swift
//  Gigs
//
//  Created by Jeffrey Carpenter on 5/9/19.
//  Copyright © 2019 Jeffrey Carpenter. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case signIn
}

class LoginViewController: UIViewController {
    
    var gigController: GigController?
    var loginType = LoginType.signUp
    
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginTypeSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signInButton.layer.cornerRadius = 8.0
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        
        view.endEditing(true)
        
        guard let gigController = gigController,
        let username = usernameTextField.text,
        !username.isEmpty,
        let password = passwordTextField.text,
        !password.isEmpty
        else { return }
        
        let user = User(username: username, password: password)
        
        if loginType == .signUp {
            
            gigController.signUp(with: user) { error in
                
                if let error = error {
                    NSLog("Error when attempting to sign up: \(error)")
                    return
                }
                
                DispatchQueue.main.async {
                    
                    // Present a successful sign up alert
                    let alert = UIAlertController(title: "Sign Up Successful", message: nil, preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(alertAction)
                    
                    self.present(alert, animated: true) {
                        
                        // change UI for easy log in
                        self.loginType = .signIn
                        self.loginTypeSegmentedControl.selectedSegmentIndex = 1
                        self.signInButton.setTitle("Log In", for: .normal)
                    }
                }
            }
        } else {
            
            gigController.signIn(with: user) { error in
                
                if let error = error {
                    NSLog("Error when attempting to log in: \(error)")
                    return
                }
                
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func signInTypeChanged(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            loginType = .signUp
            signInButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .signIn
            signInButton.setTitle("Log In", for: .normal)
        }
    }
}
