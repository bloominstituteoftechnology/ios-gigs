//
//  LogInViewController.swift
//  Gigs
//
//  Created by Chris Gonzales on 2/12/20.
//  Copyright © 2020 Chris Gonzales. All rights reserved.
//

import UIKit

enum LoginType{
    case signUp
    case login
}

class LogInViewController: UIViewController {
    
    // MARK: - Properties
    
    var gigController: GigController?
    var loginType = LoginType.signUp
    
    
    // MARK: - Outlets and Actions
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var signInButton: UIButton!
    
    @IBAction func segmentSelected(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            loginType = .signUp
            signInButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .login
            signInButton.setTitle("Log In", for: .normal)
        }
        
    }
    @IBAction func buttonTapped(_ sender: UIButton) {
        guard let gigController = gigController else { return }
        
        if let username = usernameTextField.text,
            !username.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty {
            let user = User(username: username, password: password)
            
            if loginType == .signUp{
                gigController.signUp(with: user) { (error) in
                    if let error = error {
                        NSLog("Error occurred during sign up: \(error)")
                    } else {
                        DispatchQueue.main.async {
                            self.signUpAlert()
                        }
                    }
                }
            }else {
                gigController.logIn(with: user) { (error) in
                    if let error = error {
                        NSLog("Error logging in: \(error)")
                    } else {
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
        }
        
    }
    
    // MARK: - Methods
    
    func signUpAlert(){
        let signUpAlert = UIAlertController(title: "Sign Up Successful", message: "Please log in.", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default
            , handler: nil)
        signUpAlert.addAction(alertAction)
        self.present(signUpAlert, animated: true) {
            self.loginType = .login
            self.segmentedControl.selectedSegmentIndex = 1
            self.signInButton.setTitle("Sign In", for: .normal)
        }
    }
}
