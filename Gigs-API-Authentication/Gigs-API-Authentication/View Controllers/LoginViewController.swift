//
//  LoginViewController.swift
//  Gigs-API-Authentication
//
//  Created by Jonalynn Masters on 10/2/19.
//  Copyright © 2019 Jonalynn Masters. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    //MARK: Properties
    var gigController: GigController!
    var loginType = LoginType.signUp
    
    //MARK: Outlets
    
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginTypeSegmentedControl: UISegmentedControl!
    @IBOutlet var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: Actions
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        
        guard let username = usernameTextField.text,
            let password = passwordTextField.text,
        username != "",
            password != "" else { return }
        
        let user = User(username: username, password: password)
        
        if loginType == .signUp {
            signUp(with: user)
        } else {
            signIn(with: user)
        }
    }
    
    @IBAction func signInTypeChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            loginType = .signUp
            signInButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .signIn
            signInButton.setTitle("Sign In", for: .normal)
        }
    }

    
    func signUp(with user: User) {
        gigController?.signUp(with: user, completion: { (error) in
            
            if let error = error {
                NSLog("Error occured during sign up: \(error)")
            } else {
               
                // add an alert
                
                let alert = UIAlertController(title: "Sign Up Successful",
                                              message: "Now please log in",
                                              preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK",
                                             style: .default,
                                             handler: nil)
                
                alert.addAction(okAction)
                
                // set what happens, in this case you hit ok and it changes to sign in
                
                DispatchQueue.main.async {
                    self.present(alert, animated: true) {
                        self.loginType = .signIn
                        self.loginTypeSegmentedControl.selectedSegmentIndex = 1
                        self.signInButton.setTitle("Sign In", for: .normal)
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

enum LoginType: String {
    case signUp
    case signIn
}
