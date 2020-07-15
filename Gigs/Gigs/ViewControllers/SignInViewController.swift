//
//  SignInViewController.swift
//  Gigs
//
//  Created by Cora Jacobson on 7/11/20.
//  Copyright © 2020 Cora Jacobson. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    
    enum LoginType {
        case signUp
        case signIn
    }
    
    var gigController: GigController?
    var loginType = LoginType.signUp

    @IBOutlet weak var signInSegmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signInButton.layer.cornerRadius = 8
    }
    @IBAction func signInTypeSegmentedControl(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            loginType = .signUp
            signInButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .signIn
            signInButton.setTitle("Sign In", for: .normal)
        }
    }
    
    @IBAction func signInButton(_ sender: UIButton) {
               if let username = usernameTextField.text,
                !username.isEmpty,
                let password = passwordTextField.text,
                !password.isEmpty {
                let user = User(username: username, password: password)
                switch loginType {
                case .signUp:
                    gigController?.signUp(with: user, completion: { (result) in
                        do {
                            let success = try result.get()
                            if success {
                                DispatchQueue.main.async {
                                    let alertController = UIAlertController(title: "Sign up successful!", message: "Please log in.", preferredStyle: .alert)
                                    let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                    alertController.addAction(alertAction)
                                    self.present(alertController, animated: true) {
                                        self.loginType = .signIn
                                        self.signInSegmentedControl.selectedSegmentIndex = 1
                                        self.signInButton.setTitle("Sign In", for: .normal)
                                    }
                                }
                            }
                        } catch {
                            print("Error signing up: \(error)")
                        }
                    })
                case .signIn:
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
                                case .noData, .noToken:
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
    
}
