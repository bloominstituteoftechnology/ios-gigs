//
//  LoginViewController.swift
//  Gigs
//
//  Created by Matthew Martindale on 3/14/20.
//  Copyright © 2020 Matthew Martindale. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case logIn
}

class LoginViewController: UIViewController {
    
    var gigController: GigController?
    var loginType = LoginType.signUp

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginSignInButton: UIButton!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        loginSignInButton.layer.cornerRadius = 10
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        guard let gigController = gigController else { return }
        
        guard let username = userNameTextField.text,
            username.isEmpty == false,
            let password = passwordTextField.text,
            password.isEmpty == false else { return }
        
        let user = User(username: username, password: password)
        
        switch loginType {
        case .signUp:
            gigController.signUp(with: user) { (error) in
                guard error == nil else {
                    print("Error signing up: \(error!)")
                    return
                }
                
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "Sign Up Successful", message: "Now please log in", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alertController.addAction(okAction)
                    
                    self.present(alertController, animated: true) {
                        self.loginType = .logIn
                        self.segmentedControl.selectedSegmentIndex = 1
                        self.loginSignInButton.setTitle("Log In", for: .normal)
                    }
                }
            }
        case .logIn:
            gigController.logIn(with: user) { (error) in
                guard error == nil else {
                    print("Error logging in: \(error!)")
                    return
                }
                
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func signInTypeChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            loginType = .signUp
            loginSignInButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .logIn
            loginSignInButton.setTitle("Log In", for: .normal)
        }
    }
    
}
