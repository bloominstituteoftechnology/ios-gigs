//
//  LoginViewController.swift
//  gigs
//
//  Created by Hector Steven on 5/9/19.
//  Copyright © 2019 Hector Steven. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		signInUpButtonOutlet.backgroundColor = .green
		signInUpButtonOutlet.tintColor = .green
		signInUpButtonOutlet.layer.cornerRadius = 8.0
    }
	
	@IBAction func singInUpButton(_ sender: UIButton) {
		
		
		
	}
	
	@IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
		if sender.selectedSegmentIndex == 0 {
			loginType = .SignUp
			signInUpButtonOutlet.setTitle("Sign Up", for: .normal)
		} else {
			loginType = .SignIn
		signInUpButtonOutlet.setTitle("Sign In", for: .normal)
		}
	}
	
	@IBOutlet var signInUpButtonOutlet: UIButton!
	@IBOutlet var usernameTextField: UITextField!
	@IBOutlet var passwordTextField: UITextField!
	@IBOutlet var segmentedControl: UISegmentedControl!
	var loginType = LoginType.SignUp
	var gigController: GigController?
}


