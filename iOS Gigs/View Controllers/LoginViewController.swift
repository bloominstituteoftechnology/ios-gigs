//
//  LoginViewController.swift
//  iOS Gigs
//
//  Created by Andrew Ruiz on 9/4/19.
//  Copyright © 2019 Andrew Ruiz. All rights reserved.
//

import UIKit

enum LoginType {
    case signup
    case signin
}

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    var gigController: GigController?
    var loginType : LoginType = .signup
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func segmentedControlButtonTapped(_ sender: UISegmentedControl) {
        
        // 0 is "Sign up". 1 is "Sign In"
        if sender.selectedSegmentIndex == 0 {
            loginType = .signup
            signInButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .signin
            signInButton.setTitle("Sign In", for: .normal)
        }
    }
    
    @IBAction func signUpLoginButtonTapped(_ sender: Any) {
        
        guard let username = usernameTextField.text,
        let password = passwordTextField.text,
        !username.isEmpty,
        !password.isEmpty else { return }
        
        let user = User(username: username, password: password)
        
        if loginType == .signup {
            
            gigController?.signUp(with: user, completion: { (networkError) in
                
                print("Alert")
                if let error = networkError {
                    NSLog("Error occurred during sign up: \(error)")
                } else {
                    
                    let alert = UIAlertController(title: "Sign Up Successful", message: "Now please sign in", preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    
                    alert.addAction(okAction)
                    
                    DispatchQueue.main.async {
                        self.present(alert, animated: true, completion: {
                            self.loginType = .signin
                            self.loginTypeSegmentedControl.selectedSegmentIndex = 1
                            self.signInButton.setTitle("Sign In", for: .normal)
                        })
                    }
                }
            }
            )
        } else if loginType == .signin {
            gigController?.login(with: user, completion: { (networkError) in
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
}
