//
//  LoginVC.swift
//  Gigs
//
//  Created by Jeffrey Santana on 8/7/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
	
	//MARK: - IBOutlets
	
	@IBOutlet weak var signTypeSegControl: UISegmentedControl!
	@IBOutlet weak var usernameTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var signInBtn: UIButton!
	
	//MARK: - Properties
	
	enum LoginType {
		case signUp
		case signIn
	}
	
	var gigController: GigController!
	var loginType: LoginType {
		switch signTypeSegControl.selectedSegmentIndex {
		case 1:
			return .signIn
		default:
			return .signUp
		}
	}
	
	//MARK: - Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		
	}
	
	//MARK: - IBActions
	
	@IBAction func signTypeSegControlChanged(_ sender: UISegmentedControl) {
		switch loginType {
		case .signUp:
			signInBtn.setTitle("Sign Up", for: .normal)
		case .signIn:
			signInBtn.setTitle("Sign In", for: .normal)
		}
	}
	
	@IBAction func signBtnTapped(_ sender: Any) {
		guard let username = usernameTextField.optionalText, let password = passwordTextField.optionalText else { return }
		
		switch loginType {
		case .signUp:
			gigController.createUser(username: username, password: password) { (error) in
				guard error == nil else { return }
				DispatchQueue.main.async {
					let alert = UIAlertController(title: "Sign Up Successful", message: "Account created.", preferredStyle: .alert)
					alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
						self.signTypeSegControl.selectedSegmentIndex = 1
						self.signInBtn.setTitle("Sign In", for: .normal)
					}))
					self.present(alert, animated: true)
				}
			}
		case .signIn:
			gigController.loginUser(username: username, password: password) { (error) in
				guard error == nil else { return }
				DispatchQueue.main.async {
					let alert = UIAlertController(title: "Log in Successful", message: nil, preferredStyle: .alert)
					alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
						self.dismiss(animated: true, completion: nil)
					}))
					self.present(alert, animated: true)
				}
			}
		}
	}
	
	//MARK: - Helpers
	

}

extension UITextField {
	var optionalText: String? {
		let trimmedText = self.text?.trimmingCharacters(in: .whitespacesAndNewlines)
		return (trimmedText ?? "").isEmpty ? nil : trimmedText
	}
}
