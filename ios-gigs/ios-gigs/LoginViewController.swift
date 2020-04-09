//
//  LoginViewController.swift
//  ios-gigs
//
//  Created by Shawn James on 4/7/20.
//  Copyright © 2020 Shawn James. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    enum LoginType {
        case signUp
        case logIn
    }
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var button: UIButton!
    
    var gigController: GigController?
    
    var loginType = LoginType.logIn {
        didSet {
            switch loginType {
            case .logIn:
                button.setTitle("Log In", for: .normal)
            case .signUp:
                button.setTitle("Sign Up", for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loginType = .signUp
    }
    
    // MARK: - Actions
    @IBAction func segmentChanged(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            loginType = .signUp
            passwordTextField.textContentType = .newPassword
        default:
            loginType = .logIn
            passwordTextField.textContentType = .password
        }
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        guard let username = usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            username.isEmpty == false,
            let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            password.isEmpty == false
            else { return }
        
        let user = User(username: username, password: password)
        
        switch loginType {
        case .logIn:
            gigController?.logIn(with: user) { loginResult in
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
                            self.segmentedControl.selectedSegmentIndex = 0
                            self.segmentedControl.sendActions(for: .valueChanged)
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
