//
//  LoginViewController.swift
//  Gigs
//
//  Created by Bohdan Tkachenko on 5/9/20.
//  Copyright © 2020 Bohdan Tkachenko. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case signIn
}

class LoginViewController: UIViewController {
    
    var gigController: GigController?
    var loginType = LoginType.signUp
    
    @IBOutlet var loginTypeSegmentedController: UISegmentedControl!
    @IBOutlet var usernametextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var signInButton: UIButton!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        if let username = usernametextField.text,
            !username.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty {
            let user = User(username: username, password: password)
            if loginType == .signUp {
                gigController?.signUp(with: user, completion: { (result) in
                    do {
                        let success = try result.get()
                        if success {
                            DispatchQueue.main.async {
                                let alertController = UIAlertController(title: "Sign Up Successful", message: "Now please log in.", preferredStyle: .alert)
                                let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                                alertController.addAction(alertAction)
                                self.present(alertController, animated: true) {
                                    self.loginType = .signIn
                                    self.loginTypeSegmentedController.selectedSegmentIndex = 1
                                    self.signInButton.setTitle("Sign In", for: .normal)
                                    self.signInButton.setTitleColor(.green, for: .normal)
                                }
                            }
                        }
                    } catch {
                        print("Error signing up: \(error)")
                    }
                })
            } else {
                gigController?.signIn(with: user, completion: { (result) in
                    do {
                        let success = try result.get()
                        if success {
                            DispatchQueue.main.async {
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                    } catch {
                        if let error = error as? GigController.NetworkError {
                            switch error {
                            case .failedSignIn:
                                print("Sign in failed")
                            case .noToken, .noData:
                                print("No data received")
                            default:
                                print("Other error occurred")
                            }
                        }
                    }
                })
            }
        }
        
    }
    
    
    
    @IBAction func signinTypeChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            loginType = .signUp
            signInButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .signIn
            signInButton.setTitle("Sign In", for: .normal)
        }
    }
    
}
