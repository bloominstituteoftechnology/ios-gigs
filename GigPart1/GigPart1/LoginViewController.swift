//
//  LoginViewController.swift
//  GigPart1
//
//  Created by Lambda_School_Loaner_218 on 12/4/19.
//  Copyright © 2019 Lambda_School_Loaner_218. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func loginTypedChanged(_ sender: UISegmentedControl) {
        
    }
    @IBAction func signInButtonTapped(_ sender: UIButton) {
    }
}
