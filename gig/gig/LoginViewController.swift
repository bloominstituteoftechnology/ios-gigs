//
//  LoginViewController.swift
//  gig
//
//  Created by Gladymir Philippe on 7/10/20.
//  Copyright © 2020 Gladymir Philippe. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case signIn
}

class LoginViewController: UIViewController {
    
    @IBOutlet weak var actionModeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var actionButton: UIButton!
    
    var gigController: GigController?
    var loginType = LoginType.signUp

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        actionButton.layer.cornerRadius = 8.0
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    @IBAction func actionModeValueDidChange(_ sender: Any) {
        if actionModeSegmentedControl.selectedSegmentIndex == 0 {
            loginType = .signUp
            actionButton.setTitle("SIGN UP", for: .normal)
        } else {
            loginType = .signIn
            actionButton.setTitle("SIGN IN", for: .normal)
        }
    }
        
    
    @IBAction func actionButtonTapped(_ sender: Any) {
        guard let gigController = gigController else { return }
        
        if let username = emailTextField.text,
            let password = passwordTextField.text,
            !username.isEmpty,
            !password.isEmpty {
            
            let user = User(username: username, password: password)
            
            if loginType == .signUp {
                gigController.signUp(for: user) { error in
                    if let error = error {
                        print("Error occured while signing up: \(error)")
                    } else {
                        DispatchQueue.main.async {
                            let alertController = UIAlertController(title: "Sign Up Successful", message: "Your new account has been created. Please Sign In.", preferredStyle: .alert)
                            let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                            self.present(alertController, animated: true, completion: {
                                self.actionModeSegmentedControl.selectedSegmentIndex = 1
                                self.loginType = .signIn
                                self.actionButton.setTitle("SIGN IN", for: .normal)
                            })
                        }
                    }
                }
            } else if loginType == .signIn {
                gigController.signIn(for: user) { error in
                    if let error = error {
                        print("Error occured while attempting to Sign In: \(error)")
                    } else {
                        print("Login Successful...")
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
