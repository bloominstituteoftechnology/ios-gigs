//
//  LoginViewController.swift
//  Gigs
//
//  Created by Joshua Rutkowski on 1/21/20.
//  Copyright © 2020 Josh Rutkowski. All rights reserved.
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
    
    // MARK: - Properties
    var gigController: GigController!
    var loginType = LoginType.signUp
    
    override func viewDidLoad() {
        super.viewDidLoad()

        signInButton.layer.cornerRadius = 8.0
    }

    
    //MARK: - IBActions
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
    guard let gigController = gigController else { return }
    guard let usernameText = usernameTextField.text,
        !usernameText.isEmpty,
        let passwordText = passwordTextField.text,
        !passwordText.isEmpty else { return }

    let user = User(username: usernameText, password: passwordText)

    if loginType == .signUp {
        gigController.signUp(with: user) { error in
            if let error = error {
                print("Error occurred during sign up: \(error)")
            } else {
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "Sign Up Successful", message: "Now please sign in.", preferredStyle: .alert)
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
        gigController.signIn(with: user) { error in
            if let error = error {
                print("Error occurred during sign in: \(error)")
            } else {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}
    
    @IBAction func signInTypeChanged(_ sender: UISegmentedControl) {
        if loginTypeSegmentedControl.selectedSegmentIndex == 0 {
             loginType = .signUp
             signInButton.setTitle("Sign Up", for: .normal)
         } else {
             loginType = .signIn
             signInButton.setTitle("Sign In", for: .normal)
         }
    }
    
}
