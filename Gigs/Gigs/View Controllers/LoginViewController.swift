//
//  LoginViewController.swift
//  Gigs
//
//  Created by Jessie Ann Griffin on 9/10/19.
//  Copyright © 2019 Jessie Griffin. All rights reserved.
//

import UIKit

enum LoginType {
    case logIn
    case signUp
}

class LoginViewController: UIViewController {

    @IBOutlet weak var loginTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    
    var gigController: GigController?
    
    var loginType = LoginType.signUp
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // customize button appearance (background, tint, and corner radius)
        logInButton.backgroundColor = UIColor(hue: 190/360, saturation: 70/100, brightness: 80/100, alpha: 1)
        logInButton.tintColor = .white
        logInButton.layer.cornerRadius = 8.0
        
    }
    
    @IBAction func segmentedControlTypeChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            loginType = .signUp
            logInButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .logIn
            logInButton.setTitle("Log In", for: .normal)
        }
    }
    
    @IBAction func logInButtonTapped(_ sender: UIButton) {
        
        guard let gigController = gigController else { return }
        
        if let username = usernameTextField.text, !username.isEmpty,
            let password = passwordTextField.text, !password.isEmpty {
            
            let user = User(username: username, password: password)
            
            if loginType == .signUp {
                gigController.signUp(with: user) { (error) in
                    if let error = error {
                        print("Error occurred during sign up: \(error)")
                    } else {
                        DispatchQueue.main.async {
                            let alertController = UIAlertController(title: "Sign Up Successful!",
                                                                    message: "Now please Log in.",
                                                                    preferredStyle: .alert)
                            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alertController.addAction(alertAction)
                            self.present(alertController, animated: true, completion: {
                                self.loginTypeSegmentedControl.selectedSegmentIndex = 1
                                self.loginType = .logIn
                                self.logInButton.setTitle("Log In", for: .normal)
                            })
                        }
                    }
                }
            } else {
                gigController.logIn(with: user) { (error) in
                    if let error = error {
                        print("Error occurred during log in: \(error)")
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
