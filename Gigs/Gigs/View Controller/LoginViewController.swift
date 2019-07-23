//
//  LoginViewController.swift
//  Gigs
//
//  Created by Hayden Hastings on 5/16/19.
//  Copyright © 2019 Hayden Hastings. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func signInTypeChanged(_ sender: Any) {
        if loginTypeSegmentedControl.selectedSegmentIndex == 0 {
            signInType = .signUp
            signInButton.setTitle("Sign Up", for: .normal)
        } else {
            signInType = .logIn
            signInButton.setTitle("Log In", for: .normal)
            navigationItem.title = "Log In"
        }
    }
    
    @IBAction func authenticate(_ sender: Any) {
        
        guard let username = usernameTextField.text,
            let password = passwordTextField.text else { return }
        switch signInType {
            
        case .signUp:
            
            gigController?.signUp(with: username, password: password, completion: { (error) in
                
                if let error = error {
                    NSLog("Error signing up: \(error)")
                } else {
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: "Sign Up Successful", message: "Now please log in.", preferredStyle: .alert)
                        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(alertAction)
                        self.present(alertController, animated: true, completion: {
                            self.signInType = .logIn
                            self.loginTypeSegmentedControl.selectedSegmentIndex = 1
                            self.signInButton.setTitle("Sign In", for: .normal)
                        })
                    }
                }
            })
            
        case .logIn:
            
            gigController?.logIn(with: username, password: password, completion: { (error) in
                if let error = error {
                    NSLog("Error logging in: \(error)")
                } else {
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            })
        }
    }
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var signInButton: UIButton!
    
    enum SignInType {
        case signUp
        case logIn
    }
    
    var signInType: SignInType = .signUp
    var gigController: GigController!
}
