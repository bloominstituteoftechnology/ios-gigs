//
//  LoginViewController.swift
//  Gigs
//
//  Created by Marissa Gonzales on 5/5/20.
//  Copyright © 2020 Joe Veverka. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController {
    // Outlets
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var signInButtonOutlet: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    
    enum LoginType {
        case signIn
        case signUp
    }
    var loginType = LoginType.signUp
    var gigController: GigController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signInButtonOutlet.tintColor = .blue
        signInButtonOutlet.layer.cornerRadius = 8.0
        
    }
    // Actions
    @IBAction func segmentedControlAction(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            loginType = .signUp
            signInButtonOutlet.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .signIn
            signInButtonOutlet.setTitle("Sign In", for: .normal)
        }
    }
    @IBAction func signInButtonAction(_ sender: Any) {
        // perform login or sign up operation based on loginType
        // unwrap text fields - 4 part if let.
        guard let gigController = gigController else { return }
        if let username = userNameTextField.text,
            !username.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty {
            let user = User(username: username, password: password)
            
            if loginType == .signUp {
                gigController.signUp(with: user) { error in
                    if let error = error {
                        print("Error occurred during sign up: \(error)")
                    } else {
                        DispatchQueue.main.async {
                            let alertController = UIAlertController(title: "Sign Up Successful", message: "Now please log in.", preferredStyle: .alert)
                            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alertController.addAction(alertAction)
                            self.present(alertController, animated: true, completion: {
                                self.loginType = .signIn
                                self.segmentedControl.selectedSegmentIndex = 1
                                self.signInButtonOutlet.setTitle("Sign In", for: .normal)
                            })
                        }
                    }
                }
            } else {
                gigController.signUp(with: user) { error in
                    if let error = error {
                        print("Error occurred during sign up: \(error)")
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
