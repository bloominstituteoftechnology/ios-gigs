//
//  LoginViewController.swift
//  Gigs
//
//  Created by Harmony Radley on 4/7/20.
//  Copyright © 2020 Harmony Radley. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    
    var gigController: GigController?
    var loginType = LoginType.signUp
    
    
    enum LoginType {
        case login
        case signUp
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.layer.cornerRadius = 8
    }
    
    
    @IBAction func loginTypeChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1:
            loginType = .login
            passwordTextField.textContentType = .password
        default:
            loginType = .signUp
            passwordTextField.textContentType = .newPassword
        }
    }
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        
        guard let username = usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                  username.isEmpty == false,
                  let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                  password.isEmpty == false
                  else { return }
        let alert: UIAlertController
        let action: () -> Void
        let user = User(username: username, password: password)
        
        switch loginType {
        case .signUp:
            alert = self.alert(title: "Success", message: "Login successful")
            
            action = {
                self.present(alert, animated: true)
                self.segmentedControl.selectedSegmentIndex = 1
                self.segmentedControl.sendActions(for: .valueChanged)
            }
        case .login:
            action = { self.dismiss(animated: true) }
        }
        action()
    }
    
    private func alert(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        return alert
    }
}
    
  
