//
//  LoginViewController.swift
//  Gigs
//
//  Created by Chad Rutherford on 12/4/19.
//  Copyright © 2019 lambdaschool.com. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signInButton.backgroundColor = UIColor(hue: 190/360, saturation: 70/100, brightness: 80/100, alpha: 1.0)
        signInButton.tintColor  = .white
        signInButton.layer.cornerRadius = 8.0
    }
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func loginTypeChanged(_ sender: UISegmentedControl) {
        
    }
}
