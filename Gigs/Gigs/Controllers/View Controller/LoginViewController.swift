//
//  LoginViewController.swift
//  Gigs
//
//  Created by Tobi Kuyoro on 15/01/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginTypeSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var signInButton: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logInTypeChanged(_ sender: Any) {
    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
    }
    
}
