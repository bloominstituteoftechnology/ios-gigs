//
//  LogInViewController.swift
//  Gigs
//
//  Created by Lambda_School_loaner_226 on 3/20/20.
//  Copyright © 2020 Lambda. All rights reserved.
//

import UIKit

enum LoginType {
    case signup
    case login
}

class LogInViewController: UIViewController {
    // MARK: IBOutlets
    @IBOutlet weak var segmentedController: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var gigController: GigController?
    var loginType = LoginType.signup
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButtonConfig()
    }
    
    // MARK: Helper Functions
    func loginButtonConfig() {
        loginButton.layer.cornerRadius = 25
    }
    
    // MARK: Actions
    @IBAction func segmentedControllerTapped(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            loginType = .signup
            loginButton.setTitle("Sign Up", for: .normal)
        } else {
            if sender.selectedSegmentIndex == 1 {
                loginType = .login
                loginButton.setTitle("Log In", for: .normal)
            }
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard let gigController = gigController else { return }
        if let username = usernameTextField.text,
            let password = passwordTextField.text,
            !username.isEmpty,
            !password.isEmpty {
            let user = User(username: username, password: password)
            if loginType == .signup {
                gigController.signUp(with: user) { (error) in
                    if let error = error {
                        NSLog("An error occured during signup: \(error)")
                    } else {
                        DispatchQueue.main.async {
                            let alertController = UIAlertController(title: "Sign Up Successful!", message: "Now please sign in", preferredStyle: .alert)
                            let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                            alertController.addAction(alertAction)
                            self.present(alertController, animated: true) {
                                self.loginType = .login
                                self.segmentedController.selectedSegmentIndex = 1
                                self.loginButton.setTitle("Log in", for: .normal)
                            }
                        }
                    }
                }
            } else {
                gigController.logIn(with: user) { (error) in
                    if let error = error {
                        NSLog("Error occured during sign in: \(error)")
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
