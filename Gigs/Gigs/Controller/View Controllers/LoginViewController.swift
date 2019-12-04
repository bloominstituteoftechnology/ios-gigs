//
//  LoginViewController.swift
//  Gigs
//
//  Created by Chad Rutherford on 12/4/19.
//  Copyright © 2019 lambdaschool.com. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case logIn
}

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    var authController: AuthenticationController!
    var loginType: LoginType = .signUp
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signInButton.backgroundColor = UIColor(hue: 190/360, saturation: 70/100, brightness: 80/100, alpha: 1.0)
        signInButton.tintColor  = .white
        signInButton.layer.cornerRadius = 8.0
    }
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        guard let authController = authController else { return }
        guard let username = usernameTextField.text, !username.isEmpty, let password = passwordTextField.text, !password.isEmpty else { return }
        let user = User(username: username, password: password)
        
        switch loginType {
        case .signUp:
            authController.signUp(with: user) { error in
                if let error = error {
                    print("Error occurred during sign up: \(error)")
                } else {
                    let alertController = UIAlertController(title: "Sign Up Successful", message: "Please log in now", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alertController, animated: true) {
                        self.loginType = .logIn
                        self.loginTypeSegmentedControl.selectedSegmentIndex = 1
                        self.signInButton.setTitle("Log In", for: .normal)
                    }
                }
            }
        case .logIn:
            authController.logIn(with: user) { error in
                if let error = error {
                    print("Error occurred during log in: \(error)")
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func loginTypeChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            loginType = .signUp
            signInButton.setTitle("Sign Up", for: .normal)
        case 1:
            loginType = .logIn
            signInButton.setTitle("Log In", for: .normal)
        default:
            break
        }
    }
}
