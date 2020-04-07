//
//  LoginViewController.swift
//  Gigs
//
//  Created by Chris Dobek on 4/7/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import UIKit

enum LoginType: String {
    case signUp = "Sign Up"
    case signIn = "Sign In"
}

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var loginTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    var gigController: GigController?
    
    var loginType: LoginType = .signIn {
        didSet {
            switch loginType {
            case .signIn:
                submitButton.setTitle("Sign In", for: .normal)
            case .signUp:
                submitButton.setTitle("Sign Up", for: .normal)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func loginTypeChanged(_ sender: Any) {
        switch loginTypeSegmentedControl.selectedSegmentIndex {
        case 0:
            loginType = .signIn
            passwordTextField.textContentType = .password
        default:
            loginType = .signUp
            passwordTextField.textContentType = .newPassword
        }
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        guard let username = usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            username.isEmpty == false,
            let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            password.isEmpty == false
            else { return }

        let user = User(username: username, password: password)
        
        switch loginType {
        case .signIn:
            gigController?.signIn(with: user) { loginResult in
                DispatchQueue.main.async {
                    let alert: UIAlertController
                    let action: () -> Void
                    
                    switch loginResult {
                    case .success(_):
                        action = {
                            self.dismiss(animated: true)
                        }
                    case .failure(_):
                        alert = self.alert(title: "Error", message: "Error during signing in")
                        action = {
                            self.present(alert, animated: true)
                        }
                    }
                    action()
                }
            }
        case .signUp:
            gigController?.signUp(with: user) { loginResult in
                        DispatchQueue.main.async {
                            let alert: UIAlertController
                            let action: () -> Void

                            switch loginResult {
                            case .success(_):
                                alert = self.alert(title: "Success", message: "Successfull sign up. Please log in.")
                                action = {
                                    self.present(alert, animated: true)
                                    self.loginTypeSegmentedControl.selectedSegmentIndex = 0
                                    self.loginTypeSegmentedControl.sendActions(for: .valueChanged)
                                }
                            case .failure(_):
                                alert = self.alert(title: "Error", message: "Error occured during log in.")
                                action = {
                                    self.present(alert, animated: true)
                                }
                            }

                            action()
                        }
                    }
                }
        }

    private func alert(title: String, message: String) -> UIAlertController {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            return alert
        }
}
