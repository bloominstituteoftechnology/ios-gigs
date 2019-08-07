//
//  LoginViewController.swift
//  Gigs
//
//  Created by Taylor Lyles on 8/7/19.
//  Copyright © 2019 Taylor Lyles. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
	
	@IBOutlet weak var loginSegmentControl: UISegmentedControl!
	@IBOutlet weak var username: UIStackView!
	@IBOutlet weak var password: UITextField!
	@IBOutlet weak var signUpLoginButton: UIButton!
	

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
	@IBAction func loginSignUpSwitch(_ sender: UISegmentedControl) {
	}
	
	@IBAction func loginSignUpButton(_ sender: UIButton) {
	}
	
}
