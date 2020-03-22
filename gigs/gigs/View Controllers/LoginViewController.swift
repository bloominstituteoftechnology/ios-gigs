//
//  LoginViewController.swift
//  gigs
//
//  Created by Waseem Idelbi on 3/17/20.
//  Copyright © 2020 WaseemID. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    //MARK: -Properties-
    
    var gigController: GigController?
    var loginType = LoginType.signUp
    
    enum LoginType {
        case signUp
        case signIn
    }
    
    //MARK: -IBOutlets and IBActions-
    
    @IBOutlet var segmentController: UISegmentedControl!
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var signButton: UIButton!
    
    @IBAction func segmentControllerTapped(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            loginType = .signUp
            signButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .signIn
            signButton.setTitle("Sign In", for: .normal)
        }
    }
    
    @IBAction func signButtonTapped(_ sender: UIButton) {
        
        guard let gigController = gigController else {return}
        guard let username = usernameTextField.text,
            !username.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty else {return}
        let user = User(username: username, password: password)
        
        switch loginType {
            
        case .signIn:
            gigController.signIn(with: user) { (error) in
                guard error == nil else {
                    print("Error logging in becuz: \(String(describing: error))")
                    return
                }
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
            
        case .signUp:
            gigController.signUp(with: user) { (error) in
                guard error == nil else {
                    print("Error signing up: \(String(describing: error))")
                    return
                }
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "Sign up Successful", message: "Now please log in", preferredStyle: .alert)
                    let alerAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(alerAction)
                    self.present(alertController, animated: true) {
                        self.loginType = .signIn
                        self.segmentController.selectedSegmentIndex = 1
                        self.signButton.setTitle("Sign In", for: .normal)
                    }
                }
            }
        } //End of switch statement
    }
    
    
} //End of class
