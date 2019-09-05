//
//  LoginViewController.swift
//  Gigs
//
//  Created by Percy Ngan on 9/4/19.
//  Copyright © 2019 Lamdba School. All rights reserved.
//

import UIKit

enum LoginType {
	case logIn
	case signUp
}


class LoginViewController: UIViewController {

	// MARK: - Outlets


	@IBOutlet weak var segmentedControl: UISegmentedControl!
	@IBOutlet weak var usernameTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var signUpButtonLabel: UIButton!

	// MARK: - Properties
	var gigController: GigController!
	var loginType = LoginType.signUp


	// MARK: -

    override func viewDidLoad() {
        super.viewDidLoad()


    }

	// MARK: - IBActions
    
	@IBAction func signInTypeChanged(_ sender: UISegmentedControl) {

		if sender.selectedSegmentIndex == 0 {
			loginType = .signUp
			signUpButtonLabel.setTitle("Sign Up", for: .normal)
		} else {
			loginType = .logIn
			signUpButtonLabel.setTitle("Sign In", for: .normal)
		}
	}


	@IBAction func signUpButtonTapped(_ sender: UIButton) {

		guard let username = usernameTextField.text,
			let password = passwordTextField.text, !password.isEmpty, !username.isEmpty else {return}

		let user = User(username: username, password: password)

		if loginType == .signUp {

			gigController?.signUp(with: user, completion: { (networkError) in

				if let error = networkError {

					NSLog("Error occured during signup: \(error)")

				} else {

					let alert = UIAlertController(title: "Signup successful!", message: "Please sign in.", preferredStyle: .alert)
					let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)

					alert.addAction(okAction)

					DispatchQueue.main.async {

						self.present(alert, animated: true, completion: {

							self.loginType = .logIn
							self.segmentedControl.selectedSegmentIndex = 1
							self.signUpButtonLabel.setTitle("Sign In", for: .normal)})
					}
				}
			})

		} else if loginType == .logIn {

			guard let username = usernameTextField.text,
				let password = passwordTextField.text, !password.isEmpty, !username.isEmpty else {return}

			let user = User(username: username, password: password)

			gigController?.login(with: user, completion: { (networkError) in

				DispatchQueue.main.async {
					self.dismiss(animated: true, completion: nil)
				}
			})
		}
	}


    // MARK: - Navigation



}
