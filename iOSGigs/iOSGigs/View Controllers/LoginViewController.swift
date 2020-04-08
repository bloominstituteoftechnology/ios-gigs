//
//  LoginViewController.swift
//  iOSGigs
//
//  Created by Hunter Oppel on 4/7/20.
//  Copyright © 2020 LambdaSchool. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    // MARK: - Properties
    
    enum LoginType {
        case login
        case signup
    }
    
    var selectedLoginType: LoginType = .login {
        didSet {
            switch selectedLoginType {
            case .login:
                submitButton.setTitle("Log In", for: .normal)
            case .signup:
                submitButton.setTitle("Sign Up", for: .normal)
            }
        }
    }
    var gigController: GigController?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Action Handlers
    
    @IBAction func segmentControlDidChange(_ sender: Any) {
        // Not certain why the password field isnt turning into dots since im setting the content type
        switch segmentedControl.selectedSegmentIndex {
        case 1:
            selectedLoginType = .login
            passwordTextField.textContentType = .password
        default:
            selectedLoginType = .signup
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
        
        
        switch selectedLoginType {
            
        case .login:
            gigController?.logIn(for: user) { loginResult in
                DispatchQueue.main.async {
                    let alert: UIAlertController
                    let action: () -> Void
                    
                    switch loginResult {
                    case .success(_):
                        action = {
                            self.dismiss(animated: true)
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
            
        case .signup:
            gigController?.signUp(for: user) { loginResult in
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
