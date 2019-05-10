//
//  LoginViewController.swift
//  Gigs
//
//  Created by Michael Redig on 5/9/19.
//  Copyright © 2019 Michael Redig. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

	var gigController: GigController?

	@IBOutlet var loginTypeSelector: UISegmentedControl!
	@IBOutlet var usernameTextField: UITextField!
	@IBOutlet var passwordTextField: UITextField!
	@IBOutlet var passwordConfirmationTextField: UITextField!

	@IBOutlet var submitButton: UIButton!

	private(set) var loginType: LoginType = .signup

	enum LoginType: Int {
		case login
		case signup

		static func getType(_ value: Int) -> LoginType {
			switch value {
			case 0:
				return .login
			case 1:
				return .signup
			default:
				return .signup
			}
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		updateViewsFor(loginType: loginType)
	}

	@IBAction func submitButtonTapped(_ sender: UIButton) {
		switch loginType {
		case .login:
			login()
		case .signup:
			signUp()
		}
	}

	func signUp() {
		guard let username = usernameTextField.text, !username.isEmpty,
			let password = passwordTextField.text, !password.isEmpty,
			let passwordConfirmation = passwordConfirmationTextField.text,
			password == passwordConfirmation else { return }
		let user = User(username: username, password: password)

		gigController?.signUp(with: user, completion: { [weak self] (error) in
			if let error = error {
				print(error)
				let alertVC = UIAlertController(preferredStyle: .alert)
				alertVC.configureWith(error: error)
				DispatchQueue.main.async {
					self?.present(alertVC, animated: true)
				}
			} else {
				DispatchQueue.main.async {
					let alertVC = UIAlertController(title: "Congrats", message: "You've created an account, \(username)! Please log in.", preferredStyle: .alert)
					alertVC.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) in
						self?.updateViewsFor(loginType: .login)
					}))
					self?.present(alertVC, animated: true)
				}
			}
		})
	}

	func login() {
		guard let username = usernameTextField.text, !username.isEmpty,
			let password = passwordTextField.text, !password.isEmpty
			else { return }
		let user = User(username: username, password: password)

		gigController?.login(with: user, completion: { [weak self] (error) in
			if let error = error {
				let alertVC = UIAlertController(preferredStyle: .alert)
				alertVC.configureWith(error: error)
				DispatchQueue.main.async {
					self?.present(alertVC, animated: true)
				}
			} else {
				DispatchQueue.main.async {
					self?.dismiss(animated: true)
				}
			}
		})
	}

	@IBAction func loginSelectorValueChanged(_ sender: UISegmentedControl) {
		let loginType = LoginType.getType(sender.selectedSegmentIndex)
		updateViewsFor(loginType: loginType)
	}

	func updateViewsFor(loginType: LoginType) {
		self.loginType = loginType
		loginTypeSelector.selectedSegmentIndex = loginType.rawValue
		switch loginType {
		case .login:
			submitButton.setTitle("Log In", for: .normal)
			passwordConfirmationTextField.isHidden = true
		case .signup:
			submitButton.setTitle("Sign Up", for: .normal)
			passwordConfirmationTextField.isHidden = false
		}
	}
}

