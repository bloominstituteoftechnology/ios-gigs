//
//  LoginViewController.swift
//  Gigs
//
//  Created by Matthew Martindale on 3/14/20.
//  Copyright © 2020 Matthew Martindale. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginSignInButton: UIButton!
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        loginSignInButton.layer.cornerRadius = 10
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

}
