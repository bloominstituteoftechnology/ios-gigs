//
//  LoginViewController.swift
//  ios-Gigs
//
//  Created by Gi Pyo Kim on 10/2/19.
//  Copyright © 2019 GIPGIP Studio. All rights reserved.
//

import UIKit

enum LoginType: Int {
    case signUp = 0
    case signIn = 1
}

class LoginViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var loginTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    // MARK: - Properties
    var gigController: GigController!
    var loginType: LoginType = .signUp
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func signUp(with user: User) {
        gigController?.signUp(with: user) { (error) in
            if let error = error {
                NSLog("Error occurred during sign up: \(error)")
            } else {
                let alert = UIAlertController(title: "Sign Up Successful", message: "Now please log in", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                
                DispatchQueue.main.async {
                    self.present(alert, animated: true) {
                        self.loginType = .signIn
                        self.loginTypeSegmentedControl.selectedSegmentIndex = self.loginType.rawValue
                        self.signInButton.setTitle("Sign In", for: .normal)
                    }
                }
            }
        }
    }
    
    func signIn(with user: User) {
        gigController?.signIn(with: user) { (error) in
            if let error = error {
                NSLog("Error occured during sign in \(error)")
            } else {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    
    // MARK: - Actions
    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            loginType = .signUp
            signInButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .signIn
            signInButton.setTitle("Sign In", for: .normal)
        }
    }
    
    @IBAction func signInButtonTabbed(_ sender: UIButton) {
        guard let username = usernameTextField.text, !username.isEmpty,
            let password = passwordTextField.text, !password.isEmpty else { return }

        let user = User(username: username, password: password)

        if loginType == .signUp {
            signUp(with: user)
        } else {
            signIn(with: user)
        }

    }
}
