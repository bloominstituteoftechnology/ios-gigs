//
//  LoginViewController.swift
//  Gigs
//
//  Created by Mitchell Budge on 5/16/19.
//  Copyright © 2019 Mitchell Budge. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    var gigController: GigController!
    var signInType: SignInType = .signUp
    enum SignInType {
        case signUp
        case logIn
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBOutlet weak var loginSegmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func loginSegmentedControlTapped(_ sender: Any) {
        if loginSegmentedControl.selectedSegmentIndex == 0 {
            signInType = .signUp
            loginButton.setTitle("Sign Up", for: .normal)
        } else {
            signInType = .logIn
            loginButton.setTitle("Log In", for: .normal)
        }
    } // end of segment control
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let username = usernameTextField.text,
            let password = passwordTextField.text else { return }
        switch signInType {
        case .signUp:
            
            gigController?.signUp(with: username, password: password, completion: { (error) in
                if let error = error {
                    NSLog("Error signing up: \(error)")
                } else {
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: "Sign Up Successful", message: "Now please log in.", preferredStyle: .alert)
                        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(alertAction)
                        self.present(alertController, animated: true, completion: {
                            self.signInType = .logIn
                            self.loginSegmentedControl.selectedSegmentIndex = 1
                            self.loginButton.setTitle("Sign In", for: .normal)
                        })
                    }
                }
            })
        case .logIn:
            gigController?.logIn(with: username, password: password, completion: { (error) in
                if let error = error {
                    NSLog("Error logging in: \(error)")
                } else {
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            })
        }
    } // end of login button
}
