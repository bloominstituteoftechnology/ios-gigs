//
//  LogInViewController.swift
//  Gigs
//
//  Created by Jessie Ann Griffin on 11/5/19.
//  Copyright © 2019 Jessie Griffin. All rights reserved.
//

import UIKit


enum LoginType {
    case signUp
    case logIn
}

class LogInViewController: UIViewController {

    @IBOutlet weak var loginSegmentedController: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var gigController: GigController?
    var loginType = LoginType.signUp
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.backgroundColor = UIColor(hue: 190/360, saturation: 70/100, brightness: 80/100, alpha: 1.0)
        loginButton.tintColor = .white
        loginButton.layer.cornerRadius = 8.0
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        // perform login or sign up operation based on loginType
        guard let gigController = gigController else { return }
        
        if let username = usernameTextField.text, !username.isEmpty,
            let password = passwordTextField.text, !password.isEmpty {
            let user = User(username: username, password: password)
            
            if loginType == .signUp {
                gigController.signUp(with: user) { error in
                    if let error = error {
                        print("Error occurred during signup: \(error)") // this is where complicated error handling would happen with alerts shown to user
                    } else {
                        DispatchQueue.main.async {
                            // create alert controller to show the user signup was successful
                            let alertController = UIAlertController(title: "Sign Up Successful", message: "Now please log in.", preferredStyle: .alert)
                            let alerAction = UIAlertAction(title: "OK", style: .default, handler: nil) // default automatically dismisses controller
                            alertController.addAction(alerAction)
                            self.present(alertController, animated: true) { // once it's showing it will run completion closure
                                self.loginType = .logIn
                                self.loginSegmentedController.selectedSegmentIndex = 1
                                self.loginButton.setTitle("Log In", for: .normal)
                            }
                        }
                    }
                }
            } else {
                // Run sign in API call
                gigController.logIn(with: user) { error in
                    if let error = error {
                        print("Error occurred during log in: \(error)") // this is where complicated error handling would happen with alerts shown to user
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
        if sender.selectedSegmentIndex == 0 {
            loginType = .signUp
            loginButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .logIn
            loginButton.setTitle("Log In", for: .normal)
        }
    }
}
