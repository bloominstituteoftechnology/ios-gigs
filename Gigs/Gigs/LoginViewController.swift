//
//  LoginViewController.swift
//  Gigs
//
//  Created by Isaac Lyons on 10/2/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

enum LoginType: String {
    case signUp = "Sign Up"
    case signIn = "Sign In"
}

class LoginViewController: UIViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var loginTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    //MARK: Properties
    
    var gigController: GigController?
    var loginType: LoginType = .signIn
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //MARK: Private
    
    private func updateButton() {
        signInButton.setTitle(loginType.rawValue, for: .normal)
    }
    
    private func signIn(with user: User) {
        gigController?.signIn(with: user, completion: { (error) in
            if let error = error {
                NSLog("Error signing in: \(error)")
            } else {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        })
    }
    
    private func signUp(with user: User) {
        gigController?.signUp(with: user, completion: { (error) in
            if let error = error {
                NSLog("Error signing in: \(error)")
            } else {
                let alert = UIAlertController(title: "Sign Up Successful",
                                              message: "Now please log in",
                                              preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                alert.addAction(okAction)
                
                DispatchQueue.main.async {
                    self.present(alert, animated: true) {
                        self.loginType = .signIn
                        self.loginTypeSegmentedControl.selectedSegmentIndex = 0
                        self.updateButton()
                    }
                }
            }
        })
    }
    
    //MARK: Actions
    
    @IBAction func loginTypeChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            loginType = .signIn
        } else {
            loginType = .signUp
        }
        updateButton()
    }
    
    @IBAction func signInTapped(_ sender: UIButton) {
        guard let username = usernameTextField.text,
        let password = passwordTextField.text,
        !username.isEmpty,
        !password.isEmpty else { return }
        
        let user = User(username: username, password: password)
        
        if loginType == .signIn {
            signIn(with: user)
        } else {
            signUp(with: user)
        }
    }
}

