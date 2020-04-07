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
    @IBOutlet weak var signInButton: UIButton!
    
    enum LoginType {
        case login
        case signup
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signInButton.layer.cornerRadius = 8 
    }
    

    @IBAction func signInButtonTapped(_ sender: Any) {
    }
    
    @IBAction func signUpSegmentedChanged(_ sender: Any) {
    }
    

}
