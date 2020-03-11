//
//  LoginViewController.swift
//  Gigs
//
//  Created by Jesse Ruiz on 10/2/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case signIn
}

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    var gigController: GigController!
    var loginType = LoginType.signUp
    
    // MARK: - Outlets
    @IBOutlet weak var signInSignUpSegment: UISegmentedControl!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signUpLoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signUpLoginButton.layer.cornerRadius = 8.0
    }
    
    // MARK: - Actions
    @IBAction func segmentChange(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            loginType = .signUp
            signUpLoginButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .signIn
            signUpLoginButton.setTitle("Sign In", for: .normal)
        }
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        guard let username = username.text,
            let password = password.text,
            !username.isEmpty,
            !password.isEmpty else { return }
        
        let user = User(username: username, password: password)
        
        if loginType == .signUp {
            signUp(with: user)
        } else {
            signIn(with: user)
        }
    }
    
    // MARK: - Methods
    func signUp(with user: User) {
        gigController?.signUp(with: user, completion: { (error) in
            
            if let error = error {
                NSLog("Error occured during signup: \(error)")
            } else {
                let alert = UIAlertController(title: "Sign Up Successful!",
                                              message: "Now please log in",
                                              preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK",
                                             style: .default,
                                             handler: nil)
                
                alert.addAction(okAction)
                
                DispatchQueue.main.async {
                    self.present(alert, animated: true) {
                        self.loginType = .signIn
                        self.signInSignUpSegment.selectedSegmentIndex = 1
                        self.signUpLoginButton.setTitle("Sign In", for: .normal)
                    }
                }
            }
        })
    }
    
    func signIn(with user: User) {
        gigController?.signIn(with: user, completion: { (error) in
            if let error = error {
                NSLog("Error occured during sign in: \(error)")
            } else {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        })
    }
}










