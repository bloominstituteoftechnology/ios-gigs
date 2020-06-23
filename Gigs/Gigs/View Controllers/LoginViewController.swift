//
//  ViewController.swift
//  Gigs
//
//  Created by morse on 10/30/19.
//  Copyright © 2019 morse. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var loginTypeSegmentedControl: UISegmentedControl!
    
    enum LoginType {
        case signIn, signUp
    }
    
    var gigController: GigController?
    var loginType: LoginType = .signUp
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signInButton.backgroundColor = .blue
        signInButton.tintColor = .white
        signInButton.layer.cornerRadius = 8.0
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        guard let gigController = gigController else { return }
        guard let username = usernameTextField.text,
            !username.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty else { return }
        
        let user = User(username: username, password: password)
        
        if loginType == .signUp {
            gigController.signUp(with: user) { error in
                if let error = error {
                    print("Error occurred during signup: \(error)")
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
    
    @IBAction func SignInTypeChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            loginType = .signUp
            signInButton.setTitle("Sign Up", for: .normal)
        default:
            loginType = .signIn
            signInButton.setTitle("Sign In", for: .normal)
        }
    }
    
    
}

