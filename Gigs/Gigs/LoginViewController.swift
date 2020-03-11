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
                // We don't have a valid username and password
                // We should prompt the user to enter them
                return
        }
        
        let user = User(username: username, password: password)
        
        if loginType == .signup {
            signup(withUser: user)
        } else {
            login(withUser: user)
        }
    }
    
    
    //MARK: - Properties
    
    var gigController: GigController?
    
    
    //MARK: - Private
    
    private var loginType: LoginType = .signup
    
    private func signup(withUser user: User) {
        // Let user know visually that we are signing up
        presentLoadingScreen(withMessage: "Signing up for new account")
        
        gigController?.signup(withUser: user) { error in
            DispatchQueue.main.async {
                self.loadingScreenVC.dismiss(animated: true) {
                    if let error = error {
                        // If there was an error, we should let the user know
                        NSLog("Error signing up: \(error)")
                    } else {
                        // Let the user know that they were successfully signed up
                        
                        let successAlert = UIAlertController(title: "Success", message: "Your account was created successfully. You may now use the Gigs app", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                            // Automatically log in when they hit ok
                            self.login(withUser: user)
                        }
                        successAlert.addAction(okAction)
                        self.present(successAlert, animated: true)
                    }
                }
            }
        }
    }
    
    private func login(withUser user: User) {
        // Let user know visually that we are logging in
        presentLoadingScreen(withMessage: "Logging in")
        
        gigController?.login(withUser: user) { error in
            DispatchQueue.main.async {
                self.loadingScreenVC.dismiss(animated: true) {
                    if let error = error {
                        // If there was an error, we should let the user know
                        NSLog("Error logging in: \(error)")
                    } else {
                        self.dismiss(animated: true)
                    }
                }
            }
        }
    }
    
    private lazy var loadingScreenVC: LoadingScreenViewController = (storyboard?.instantiateViewController(identifier: "LoadingScreen")) as! LoadingScreenViewController
    
    func presentLoadingScreen(withMessage message: String) {
        loadingScreenVC.message = message
        loadingScreenVC.modalPresentationStyle = .fullScreen
        loadingScreenVC.modalTransitionStyle = .crossDissolve
        present(loadingScreenVC, animated: true)
    }

}
