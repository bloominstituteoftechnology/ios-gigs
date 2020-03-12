//
//  LoginViewController.swift
//  Gigs
//
//  Created by Shawn Gee on 3/11/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    enum LoginType: Int {
        case signup, login
    }

    //MARK: - IBOutlets
    
    @IBOutlet weak var loginTypeSelector: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signupLoginButton: UIButton!
    
    
    //MARK: - IBActions
    
    @IBAction func loginTypeSelected(_ sender: UISegmentedControl) {
        loginType = LoginType(rawValue: sender.selectedSegmentIndex) ?? .signup
        signupLoginButton.setTitle(loginType == .signup ? "Sign Up" : "Log In", for: .normal)
    }
    
    @IBAction func signupLoginButtonTapped(_ sender: UIButton) {
        guard let username = usernameTextField.text,
            !username.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty else {
                return
        }
        
        let user = User(username: username, password: password)
        
        if loginType == .signup {
            loadingScreenVC.message = "Signing Up..."
            present(loadingScreenVC, animated: true)
            signup(withUser: user)
        } else {
            loadingScreenVC.message = "Logging In..."
            present(loadingScreenVC, animated: true)
            login(withUser: user)
        }
    }
    
    
    //MARK: - Properties
    
    var gigController: GigController?
    
    
    //MARK: - Private
    
    private lazy var loadingScreenVC = storyboard?.instantiateViewController(identifier: "LoadingScreen") as! LoadingScreenViewController
    
    private var loginType: LoginType = .signup
    
    private func signup(withUser user: User) {
        gigController?.newSignup(withUser: user) { error in
            DispatchQueue.main.async {
                
                if let error = error {
                    self.loadingScreenVC.dismiss(animated: true) {
                        NSLog("Error signing up: \(error)")
                        
                        let failureAlert = UIAlertController(title: "Ooops",
                                                             message: "We were unable to make an account for you for some reason.",
                                                             preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default)
                        failureAlert.addAction(okAction)
                        
                        self.present(failureAlert, animated: true)
                    }
                } else {
                    // Success
                    self.loadingScreenVC.message = "Sign Up Successful, \n Logging In..."
                    self.login(withUser: user)
                }
            }
        }
    }
    
    private func login(withUser user: User) {
        gigController?.newLogin(withUser: user) { error in
            DispatchQueue.main.async {
                self.loadingScreenVC.dismiss(animated: true) {
                    
                    if let error = error {
                        NSLog("Error logging in: \(error)")
                        
                        let failureAlert = UIAlertController(title: "Login Failed",
                                                             message: "Check your username and password",
                                                             preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default)
                        failureAlert.addAction(okAction)
                        
                        self.present(failureAlert, animated: true)
                        
                    } else {
                        // Success
                        self.dismiss(animated: true)
                    }
                }
            }
        }
    }
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }
}


// MARK: - Text Field Delegate

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let username = usernameTextField.text, let password = passwordTextField.text else { return }
        signupLoginButton.isEnabled = !username.isEmpty && !password.isEmpty
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === usernameTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            signupLoginButtonTapped(signupLoginButton)
        }
        return true
    }
}



