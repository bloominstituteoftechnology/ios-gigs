//
//  LoginViewController.swift
//  Gigs
//
//  Created by Ciara Beitel on 9/4/19.
//  Copyright © 2019 Ciara Beitel. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case signIn
}

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    var gigController: GigController!
    var loginType = LoginType.signUp
    
    // MARK: - Outlets
    
    @IBOutlet weak var signUpOrInSegCon: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpOrInButton: UIButton!
    
    // MARK: - Action Handlers
    
    @IBAction func signUpOrInButton(_ sender: UIButton) {
        guard let username = usernameTextField.text,
            let password = passwordTextField.text,
            !username.isEmpty,
            !password.isEmpty else { return }
        
        let user = User(username: username, password: password)
        
        if loginType == .signUp {
            gigController.signUp(with: user, completion: { (networkError) in
                if let error = networkError {
                    NSLog("Error occurred during sign up: \(error)")
                } else {
                    let alert = UIAlertController(title: "Sign up was successful.", message: "Please log in.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(okAction)
                    
                    DispatchQueue.main.async {
                        self.present(alert, animated: true, completion: {
                            self.loginType = .signIn
                            self.signUpOrInSegCon.selectedSegmentIndex = 1
                            self.signUpOrInButton.setTitle("Sign In", for: .normal)
                        })
                    }
                }
            })
        } else if loginType == .signIn {
            gigController.login(with: user, completion: {(networkError) in
                if let error = networkError {
                    NSLog("Error occurred during login: \(error)")
                } else {
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            })
        }
    }
    
    @IBAction func signUpOrInSegCon(_ sender: UISegmentedControl) {
        if signUpOrInSegCon.selectedSegmentIndex == 0 {
            loginType = .signUp
            signUpOrInButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .signIn
            signUpOrInButton.setTitle("Sign In", for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.isSecureTextEntry = true
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}
