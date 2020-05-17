//
//  LoginViewController.swift
//  Gigs
//
//  Created by Clean Mac on 5/14/20.
//  Copyright © 2020 LambdaStudent. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case signIn
}

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginTypeSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var signInButton: UIButton!
    
    var apiController: APIController?
    var loginType = LoginType.signUp
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    // MARK: - Action Handlers
    @IBAction func buttonTapped(_ sender: UIButton) {
        // perform login or signup
        if let username = usernameTextField.text,
            !username.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty {
            let user = User(username: username, password: password)
            if loginType == .signUp {
                apiController?.signUp(with: user, completion: { (result) in
                    do {
                        let success = try result.get()
                        if success {
                            DispatchQueue.main.async {
                                let alertController = UIAlertController(title: "Sign Up Successful", message: "Now please log in", preferredStyle: .alert)
                                let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                alertController.addAction(alertAction)
                                self.present(alertController, animated: true) {
                                    self.loginType = .signIn
                                    self.loginTypeSegmentedControl.selectedSegmentIndex = 1
                                    self.signInButton.setTitle("Sign In", for: .normal)
                                }
                            }
                        }
                    } catch {
                        print("Error signing up: \(error)")
                    }
                })
            } else {
                apiController?.signIn(with: user, completion: { (result) in
                    do {
                        let sucess = try result.get()
                        if sucess {
                            DispatchQueue.main.async {
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                    } catch {
                        if let error = error as? APIController.NetworkError {
                            switch error {
                            case .failedSignIn:
                                print("sign in failed")
                            case .noToken, .noData:
                                print("no data received")
                            default:
                                print("no error")
                                
                            }
                        }
                    }
                })
            }
        }
    }
    
    @IBAction func signInTypeChanged(_ sender: Any) {
        // switch UI between modes
        if loginTypeSegmentedControl.selectedSegmentIndex == 0 {
            loginType = .signUp
            signInButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .signIn
            signInButton.setTitle("Sign In", for: .normal)
        }
        
    }
    
    
    
    
}
