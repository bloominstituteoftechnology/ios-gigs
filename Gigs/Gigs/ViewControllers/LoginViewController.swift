//
//  LoginViewController.swift
//  Gigs
//
//  Created by Marlon Raskin on 6/19/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
	
	@IBOutlet var loginTypeSegmentControl: UISegmentedControl!
	@IBOutlet var usernameTextField: UITextField!
	@IBOutlet var passwordTextField: UITextField!
	@IBOutlet var signInButton: UIButton!
	

    override func viewDidLoad() {
        super.viewDidLoad()
		signInButton.backgroundColor = #colorLiteral(red: 0.4857033232, green: 0.5280619806, blue: 0.7791878173, alpha: 1)
		signInButton.tintColor = .white
		signInButton.layer.cornerRadius = 15
		loginTypeSegmentControl.tintColor = #colorLiteral(red: 0.4857033232, green: 0.5280619806, blue: 0.7791878173, alpha: 1)
    }
    
	@IBAction func buttonTapped(_ sender: UIButton) {
	}
	
	@IBAction func signInTypeChanged(_ sender: UISegmentedControl) {
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
