//
//  LoginViewController.swift
//  Gigs
//
//  Created by Michael Redig on 5/9/19.
//  Copyright © 2019 Michael Redig. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
	@IBOutlet var loginTypeSelector: UISegmentedControl!
	@IBOutlet var usernameTextField: UITextField!
	@IBOutlet var passwordTextField: UITextField!
	@IBOutlet var passwordConfirmationTextField: UITextField!

	@IBOutlet var submitButton: UIButton!

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}

	@IBAction func submitButtonTapped(_ sender: UIButton) {
	}

	@IBAction func loginSelectorValueChanged(_ sender: UISegmentedControl) {
	}

}

