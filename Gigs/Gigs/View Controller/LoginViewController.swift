//
//  LoginViewController.swift
//  Gigs
//
//  Created by Taylor Lyles on 8/7/19.
//  Copyright © 2019 Taylor Lyles. All rights reserved.
//

import UIKit


enum LoginType {
	case signUp
	case logIn
}

class LoginViewController: UIViewController {
	
	var gigController: GigController!
	var loginType = LoginType.signUp
	
	@IBOutlet weak var loginSegmentControl: UISegmentedControl!
	@IBOutlet weak var username: UITextField!
	@IBOutlet weak var password: UITextField!
	@IBOutlet weak var signUpLoginButton: UIButton!
	

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
	@IBAction func loginSignUpSwitch(_ sender: UISegmentedControl) {
		guard let sender = sender as? UISegmentedControl else { return }
		if sender.selectedSegmentIndex == 0 {
			loginType = .signUp
			signUpLoginButton.setTitle("Sign Up", for: .normal)
		} else {
			loginType = .logIn
			signUpLoginButton.setTitle("Login", for: .normal)
		}
	}
	
	@IBAction func loginSignUpButton(_ sender: UIButton) {
		guard let gigController = gigController else { return }
		
		if let username = username.text, !username.isEmpty,
			let password = password.text, !password.isEmpty {
			let user = User(username: username, password: password)
			
			if loginType == .signUp {
				gigController.signUp(with: user, completion: { (error) in
					if let error = error {
						NSLog("error")
					} else {
						DispatchQueue.main.async {
							let alert = UIAlertController(title: "You are signed up", message: "Sign in successful", preferredStyle: .alert)
							let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
							alert.addAction(alertAction)
							self.present(alert, animated: true, completion: {
								self.loginType = .logIn
								self.loginSegmentControl.selectedSegmentIndex = 1
								self.signUpLoginButton.setTitle("Sign In", for: .normal)
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
