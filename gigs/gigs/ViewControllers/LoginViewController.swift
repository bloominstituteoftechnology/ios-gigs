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
	
	@IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
		setWithSegmentedControl(sender.selectedSegmentIndex)
	}

	@IBAction func singInUpButton(_ sender: UIButton) {
		guard let username = usernameTextField.text,
			let password = passwordTextField.text else { return }
		
		let user = User(username: username, password: password)
		
		if loginType == .SignUp {
			
			gigController?.signUp(with: user, completion: { error in
				if let error = error {
					print("error with sign up: \(error)")
				} else {
					DispatchQueue.main.async {
						self.pleaseLogInAlert()
					}
				}
			})
			
		} else {
			gigController?.signIn(user: user, completion: { error in
				if let error = error {
					print("error with sign in \(error)")
				} else {
					DispatchQueue.main.async {
						self.dismiss(animated: true, completion: nil)
					}
				}
			})
		}
	}
	
	func pleaseLogInAlert(){
		let alertController = UIAlertController(title: "Please Log In", message: nil, preferredStyle: .alert)
		let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
		alertController.addAction(alertAction)
		present(alertController, animated: true) {
			
			self.setWithSegmentedControl(1)
		}
	}
	
	func setWithSegmentedControl(_ index: Int) {
		segmentedControl.selectedSegmentIndex = index
		if index == 0 {
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


