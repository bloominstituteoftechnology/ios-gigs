//
//  LoginViewController.swift
//  GigPart1
//
//  Created by Lambda_School_Loaner_218 on 12/4/19.
//  Copyright © 2019 Lambda_School_Loaner_218. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    enum LoginType {
        case signUp
        case logIn
    }

    @IBOutlet weak var loginTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    var gigController: GigController!
    var loginType: LoginType = .signUp
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpButton.layer.cornerRadius = 8.0
    }
    @IBAction func loginTypedChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            loginType = .signUp
            signUpButton.setTitle("Sign Up", for: .normal)
            
        case 1:
            loginType = .logIn
            signUpButton.setTitle("Log In", for: .normal)
         
        default:
            break
        }
    }
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        guard let gigController = gigController else { return }
        guard let username = usernameTextField.text, !username.isEmpty,let password = passwordTextField.text, !password.isEmpty else { return }
        let user = User(username: username, password: password)
        
        switch loginType {
        case .signUp:
            gigController.signUp(with: user) { error in
                if let error = error {
                    print("error occurred during sign up: \(error)")
                } else {
            let alertController = UIAlertController(title: "Sign up Succesful", message: "Please log in now", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alertController, animated: true)
                    self.loginType = .logIn
                    self.loginTypeSegmentedControl.selectedSegmentIndex = 1
                    self.signUpButton.setTitle("Log in", for: .normal)
                }
            }
        case.logIn:
            gigController.login(with: user) { error in
                if let error = error {
                    print("Error occurred during log in: \(error)")
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            }
            
        }
        
    }
}
