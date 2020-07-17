//
//  LoginViewController.swift
//  Gigs
//
//  Created by Eoin Lavery on 13/07/2020.
//  Copyright © 2020 Eoin Lavery. All rights reserved.
//

import UIKit

enum LoginType {
    case login
    case signup
}

class LoginViewController: UIViewController {

    var gigController: GigController?
    var loginType: LoginType = .signup
    
    @IBOutlet weak var loginTypeSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginSignupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginSignupButton.backgroundColor = .systemGreen
        loginTypeSegmentedControl.tintColor = .systemGreen
        loginSignupButton.setTitle("Signup", for: .normal)
        loginSignupButton.titleLabel?.textColor = .white
        loginSignupButton.layer.cornerRadius = 10
    }
    
    /*
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    */

    @IBAction func loginSignupButtonPressed(_ sender: Any) {
        guard let gigController = gigController else { return }
        
        if let username = usernameTextField.text, !username.isEmpty, let password = passwordTextField.text, !password.isEmpty {
            let user = User(username: username, password: password)
            
            if loginType == .signup {
                gigController.signup(user: user) { (error) in
                    if let error = error {
                        print("Error occured when attempting to signup with details: \(error)")
                    } else {
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Signup Succeeded!", message: "Your account has been registered. Please sign in.", preferredStyle: .alert)
                            let clearAction = UIAlertAction(title: "Clear", style: .default, handler: nil)
                            alert.addAction(clearAction)
                            self.present(alert, animated: true, completion: {
                                self.loginTypeSegmentedControl.selectedSegmentIndex = 1
                                self.loginType = .login
                                self.loginSignupButton.setTitle("Login", for: .normal)
                            })
                        }
                    }
                }
            } else if loginType == .login {
                gigController.signin(user: user) { (error) in
                    if let error = error {
                        print("Error occured when attempting to login with details: \(error)")
                    } else {
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
            
        }
    }
    
    @IBAction func loginTypeSegmentedControlValueChanged(_ sender: Any) {
        switch loginTypeSegmentedControl.selectedSegmentIndex {
        case 0:
            loginType = .signup
            loginSignupButton.setTitle("Signup", for: .normal)
        case 1:
            loginType = .login
            loginSignupButton.setTitle("Login", for: .normal)
        default:
            loginType = .signup
            loginSignupButton.setTitle("Signup", for: .normal)
        }
    }
    
}
