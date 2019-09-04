//
//  LoginViewController.swift
//  Gigs
//
//  Created by Percy Ngan on 9/4/19.
//  Copyright © 2019 Lamdba School. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

	// MARK: - Outlets


	@IBOutlet weak var segmentedLabel: UISegmentedControl!
	@IBOutlet weak var usernameTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var signUpButtonLabel: UIButton!

	// MARK: - Properties

	// MARK: -

    override func viewDidLoad() {
        super.viewDidLoad()


    }

	// MARK: - IBActions
    
	@IBAction func segmentControlToggle(_ sender: UISegmentedControl) {
	}
	@IBAction func signupButtonPressed(_ sender: UIButton) {
	}


    // MARK: - Navigation



}
