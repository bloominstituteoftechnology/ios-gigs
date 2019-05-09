//
//  LoginViewController.swift
//  Gigs
//
//  Created by Christopher Aronson on 5/9/19.
//  Copyright © 2019 Christopher Aronson. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case signIn
}

class LoginViewController: UIViewController {
    // MARK: - Properties
    var gigController: GigController?
    var loginType = LoginType.signUp
    
    // MARK: - IBOutlets
    @IBOutlet weak var loginTypeSegmentControl: UISegmentedControl!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: - View Functions
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - IBActions
    @IBAction func changeLoginType(_ sender: Any) {
        guard let sender = sender as? UISegmentedControl else { return }
        if sender.selectedSegmentIndex == 0 {
            loginType = .signUp
            loginButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .signIn
            loginButton.setTitle("Sign In", for: .normal)
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let gigController = gigController else { return }
        
        if let username = userNameTextField.text,
        !username.isEmpty,
        let password = passwordTextField.text,
        !password.isEmpty {
            let user = User(username: username, password: password)
        
            if loginType == .signUp {
                gigController.signUp(with: user) { (error) in
                    if let error = error {
                        print(error)
                    } else {
                        DispatchQueue.main.async {
                            let alertController = UIAlertController(title: "Sign Up Successful", message: "Sign in successful. Please login now", preferredStyle: .alert)
                            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alertController.addAction(alertAction)
                            self.present(alertController, animated: true, completion: {
                                self.loginType = .signIn
                                self.loginTypeSegmentControl.selectedSegmentIndex = 1
                                self.loginButton.setTitle("Sign In", for: .normal)
                            })
                        }
                    }
                }
            } else {
                gigController.signIn(with: user) { (error) in
                    if let error = error {
                        print(error)
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
