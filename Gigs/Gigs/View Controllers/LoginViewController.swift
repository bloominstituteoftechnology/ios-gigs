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
        
    }
    
    
}
    
  
