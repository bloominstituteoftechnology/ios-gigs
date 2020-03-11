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
            // Let user know visually that we are signing up
            loadingScreenVC.message = "Signing Up..."
            present(loadingScreenVC, animated: true)
            signup(withUser: user)
        } else {
            // Let user know visually that we are logging in
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
        gigController?.signup(withUser: user) { error in
            DispatchQueue.main.async {
                if let error = error {
                    self.loadingScreenVC.dismiss(animated: true)
                    NSLog("Error signing up: \(error)")
                    // Show alert to let user know of error
                    
                } else {
                    // Let the user know that they were successfully signed up
                    self.loadingScreenVC.message = "Sign Up Successful, \n Logging In..."
                    self.login(withUser: user)
                }
            }
        }
    }
    
    private func login(withUser user: User) {
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
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }
}

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


//let successAlert = UIAlertController(title: "Success", message: "Your account was created successfully. You may now use the Gigs app", preferredStyle: .alert)
//let okAction = UIAlertAction(title: "OK", style: .default) { _ in
//}
//successAlert.addAction(okAction)
//self.present(successAlert, animated: true)
