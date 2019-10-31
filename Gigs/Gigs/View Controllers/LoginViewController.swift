//
//  LoginViewController.swift
//  Gigs
//
//  Created by Jon Bash on 2019-10-30.
//  Copyright © 2019 Jon Bash. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var authType: AuthType = .logIn
    var apiController: APIController?

    @IBOutlet weak var authTypeControl: UISegmentedControl!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var authButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func authTypeChangeTapped(_ sender: UISegmentedControl) {
        changeAuthType()
    }
    
    @IBAction func authButtonTapped(_ sender: UIButton) {
        guard let username = usernameField.text, !username.isEmpty,
            let password = passwordField.text, !password.isEmpty
            else { return }
        
        let user = User(username: username, password: password)
        
        if authType == .signUp {
            signUp(with: user)
        } else if authType == .logIn {
            logIn(with: user)
        }
    }
    
    private func changeAuthType() {
        switch authTypeControl.selectedSegmentIndex {
        case 0:
            authType = .logIn
        case 1:
            authType = .signUp
        default:
            break
        }
        authButton.setTitle(authType.rawValue, for: .normal)
    }
    
    private func signUp(with user: User) {
        guard let apiController = apiController else { return }
        
        apiController.handleAuth(.signUp, with: user) { error in
            if let error = error {
                print("Error occurred during sign up: \(error)")
            } else {
                DispatchQueue.main.async {
                    let alert = UIAlertController(
                        title: "Sign-up successful!",
                        message: "You may now sign in.",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "OK", style: .default) { alertAction in
                        self.authType = .logIn
                        self.authTypeControl.selectedSegmentIndex = 0
                        self.authButton.setTitle(self.authType.rawValue, for: .normal)
                    })
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    private func logIn(with user: User) {
        guard let apiController = apiController else { return }
        
        apiController.handleAuth(.logIn, with: user) { error in
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
