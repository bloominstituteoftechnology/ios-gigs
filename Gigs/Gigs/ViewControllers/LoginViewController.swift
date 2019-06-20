//
//  LoginViewController.swift
//  Gigs
//
//  Created by Marlon Raskin on 6/19/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

enum LoginType {
	case signUp
	case signIn
}

class LoginViewController: UIViewController {
	
	@IBOutlet var loginTypeSegmentControl: UISegmentedControl!
	@IBOutlet var usernameTextField: UITextField!
	@IBOutlet var passwordTextField: UITextField!
	@IBOutlet var signInButton: UIButton!
	
	var gigController: GigController!
	var loginType = LoginType.signUp
	

    override func viewDidLoad() {
        super.viewDidLoad()
		signInButton.backgroundColor = #colorLiteral(red: 0.4857033232, green: 0.5280619806, blue: 0.7791878173, alpha: 1)
		signInButton.tintColor = .white
		signInButton.layer.cornerRadius = 5
		loginTypeSegmentControl.tintColor = #colorLiteral(red: 0.4857033232, green: 0.5280619806, blue: 0.7791878173, alpha: 1)
    }
    
	@IBAction func buttonTapped(_ sender: UIButton) {
		if let username = usernameTextField.text,
			!username.isEmpty,
			let password = passwordTextField.text,
			!password.isEmpty {
			let user = User(username: username, password: password)
			if loginType == .signUp {
				gigController.signUp(with: user) { error in
					if let error = error {
						print("Error occured during sign up: \(error)")
					} else {
						DispatchQueue.main.async {
							let alertController = UIAlertController(title: "Sign Up Successful!", message: "Now please log in.", preferredStyle: .alert)
							let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
							alertController.addAction(alertAction)
							self.present(alertController, animated: true, completion: {
								self.loginType = .signIn
								self.loginTypeSegmentControl.selectedSegmentIndex = 1
								self.signInButton.setTitle("Sign In", for: .normal)
							})
						}
					}
				}
			} else {
				gigController.signIn(with: user) { error in
					if let error = error {
						print("Error occured during sign up: \(error)")
					} else {
						DispatchQueue.main.async {
							self.dismiss(animated: true, completion: nil)
						}
					}
				}
			}
		}
	}
	
	@IBAction func signInTypeChanged(_ sender: UISegmentedControl) {
		switch sender.selectedSegmentIndex {
		case 0:
			loginType = LoginType.signUp
			signInButton.setTitle("Sign Up", for: .normal)
		case 1:
			loginType = LoginType.signIn
			signInButton.setTitle("Sign In", for: .normal)
		default:											//Ask Conner why it still wants a default even though I've exhausted all options
			()
		}
	}
	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
