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
	
	
	func setWithSegmentedControl(_ index: Int) {
		if index == 0 {
			loginType = .SignUp
			signInUpButtonOutlet.setTitle("Sign Up", for: .normal)
		} else {
			loginType = .SignIn
			signInUpButtonOutlet.setTitle("Sign In", for: .normal)
		}
	}
	
	@IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
		setWithSegmentedControl(sender.selectedSegmentIndex)
	}

	@IBAction func singInUpButton(_ sender: UIButton) {
		guard let username = usernameTextField.text,
			let password = passwordTextField.text else { return }
		
		let user = User(username: username, password: password)
		
		if loginType == .SignUp {
			gigController?.signUp(with: user, completion: {
				error in
				if let error = error {
					print("error with sign up: \(error)")
				} else {
					DispatchQueue.main.async {
						self.pleaseLogInAlert()
					}
				}
			})
		} else {
			
		}
	}
	
	
	func pleaseLogInAlert(){
		let alertController = UIAlertController(title: "Please Log In", message: nil, preferredStyle: .alert)
		let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
		alertController.addAction(alertAction)
		
		
	}
	
	
	@IBOutlet var signInUpButtonOutlet: UIButton!
	@IBOutlet var usernameTextField: UITextField!
	@IBOutlet var passwordTextField: UITextField!
	@IBOutlet var segmentedControl: UISegmentedControl!
	var loginType = LoginType.SignUp
	var gigController: GigController?
}


