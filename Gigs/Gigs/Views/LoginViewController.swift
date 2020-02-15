//
//  LoginViewController.swift
//  Gigs
//
//  Created by Casualty on 9/10/19.
//  Copyright © 2019 Thomas Dye. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginSegmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInUpButton: UIButton!
    
    var gigController: GigController?
    var loginType = LoginType.signUp
    var tealTintColor: UIColor = UIColor(hue: 190/360, saturation: 70/100, brightness: 80/100, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleLoginPage()
    }
    
    func signUpOccurred() {
        self.loginSegmentedControl.selectedSegmentIndex = 1
        self.loginType = .signIn
        self.signInUpButton.setTitle("Sign In", for: .normal)
    }
    
    func styleLoginPage() {
        signInUpButton.backgroundColor = tealTintColor
        signInUpButton.tintColor = .white
        signInUpButton.layer.cornerRadius = 8.0
        loginSegmentedControl.tintColor = tealTintColor
        passwordTextField.isSecureTextEntry = true
        usernameTextField.tintColor = tealTintColor
        passwordTextField.tintColor = tealTintColor
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        guard let gigController = gigController else { return }
        
        if let username = usernameTextField.text,
            !username.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty {
            
            let user = User(username: username, password: password)
            
            if loginType == .signUp {
                gigController.signUp(with: user.username, password: user.password) { (error) in
                    if let error = error {
                        print("Error occurred during sign up: \(error)")
                    } else {
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Sign Up Successful 👍", message: "Please sign in.", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alert.addAction(okAction)
                            self.present(alert, animated: true, completion: {
                                self.signUpOccurred()
                            })
                        }
                    }
                }
            } else if loginType == .signIn {
                gigController.signIn(with: user.username, password: user.password) { (error) in
                    if let error = error {
                        print("Error occurred during sign in: \(error)")
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
            signInUpButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .signIn
            signInUpButton.setTitle("Sing In", for: .normal)
        }
    }
}
