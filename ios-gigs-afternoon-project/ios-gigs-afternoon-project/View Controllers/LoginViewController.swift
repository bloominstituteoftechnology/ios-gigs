//
//  LoginViewController.swift
//  ios-gigs-afternoon-project
//
//  Created by Alex Shillingford on 6/19/19.
//  Copyright © 2019 Alex Shillingford. All rights reserved.
//

import UIKit

enum LoginType {
    case signIn
    case signUp
}

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var signInButton: UIButton!
    
    var gigController: GigController?
    var loginType = LoginType.signUp
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        signInButton.backgroundColor = UIColor(hue: 190/360, saturation: 70/100, brightness: 80/100, alpha: 1.0)
        signInButton.tintColor = .white
        signInButton.layer.cornerRadius = 8.0
    }
    
    @IBAction func signInTypeChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            loginType = .signUp
            signInButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .signIn
            signInButton.setTitle("Sign In", for: .normal)
        }
    }
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        guard let gigController = gigController else { return }
        if let username = usernameTextField.text,
            !username.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty {
            let user = User(username: username, password: password)
            if loginType == .signUp {
                gigController.signUp(user: user, completion: { (error) in
                    if let error = error {
                        print("Error signing user up: \(error)")
                        return
                    } else {
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Sign Up Successful", message: "Now please log in.", preferredStyle: .alert)
                            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alert.addAction(alertAction)
                            self.present(alert, animated: true, completion: {
                                self.loginType = .signIn
                                self.segmentedControl.selectedSegmentIndex = 1
                                self.signInButton.setTitle("Sign In", for: .normal)
                            })
                        }
                    }
                })
            } else {
                gigController.signIn(user: user, completion: { (error) in
                    if let error = error {
                        print("Error signing in: \(error)")
                        return
                    } else {
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                })
            }
        }
    } // End of signInButtonTapped
} // End of LoginViewController
