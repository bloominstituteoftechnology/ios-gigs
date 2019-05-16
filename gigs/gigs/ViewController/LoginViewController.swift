//
//  LoginViewController.swift
//  gigs
//
//  Created by Taylor Lyles on 5/16/19.
//  Copyright © 2019 Taylor Lyles. All rights reserved.
//

import UIKit

enum LoginType {
	case signUp
	case signIn
}


class LoginViewController: UIViewController {
	

	var gigController: GigController?
	var loginType = LoginType.signUp

    override func viewDidLoad() {
        super.viewDidLoad()

		
    }
    
	@IBOutlet weak var logInSwitch: UISegmentedControl!
	@IBOutlet weak var username: UITextField!
	@IBOutlet weak var password: UITextField!
	@IBOutlet weak var logInButton: UIButton!
	
	
	
	@IBAction func logSignSwitch(_ sender: UISegmentedControl) {
		guard let sender = sender as? UISegmentedControl else { return }
		if sender.selectedSegmentIndex == 0 {
			loginType = .signUp
			logInButton.setTitle("Sign Up", for: .normal)
		} else {
			loginType = .signUp
			logInButton.setTitle("Sign In", for: .normal)
		}
	}
	
	@IBAction func loginSignButton(_ sender: Any) {
		guard let gigController = gigController else { return }
		
		if let username = username.text, !username.isEmpty,
			let password = password.text, !password.isEmpty {
			let user = User(username: username, password: password)
			
			if loginType == .signUp {
				gigController.signUp(with: user, completeion: { (error) in
					if let error = error {
						NSLog("error")
					} else {
						DispatchQueue.main.async {
							let alert = UIAlertController(title: "You are signed up", message: "Sign in successful", preferredStyle: .alert)
							let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
							alert.addAction(alertAction)
							self.present(alert, animated: true, completion: {
								self.loginType = .signIn
								self.logInSwitch.selectedSegmentIndex = 1
								self.logInButton.setTitle("Sign In", for: .normal)
							})
						}
					}
				})
			} else {
				gigController.logIn(with: user) { (error) in
					if let error = error {
						NSLog("error")
					} else {
						DispatchQueue.main.async {
							self.dismiss(animated: true, completion: nil)
						}
					}
					
				}
			}
		}
	}
	
	
}
