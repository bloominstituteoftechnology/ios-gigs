//
//  LoginViewController.swift
//  Gigs
//
//  Created by Josh Kocsis on 5/8/20.
//  Copyright © 2020 Lambda, Inc. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case signIn
}

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var sUAndLiSegmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var sUAndLiButton: UIButton!
    
    var gigController: GigController?
    var loginType = LoginType.signUp
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sUAndLiButton.backgroundColor = UIColor(hue: 190/360, saturation: 70/100, brightness: 80/100, alpha: 1.0)
            sUAndLiButton.tintColor = .white
            sUAndLiButton.layer.cornerRadius = 8.0
    }
    
    @IBAction func suAndLIButtonTapped(_ sender: Any) {
        if let username = usernameTextField.text,
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
                                    let alerController = UIAlertController(title: "Sign Up Successful!", message: "Now please log in.", preferredStyle: .alert)
                                    let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                                    alerController.addAction(alertAction)
                                    self.present(alerController, animated: true) {
                                        self.loginType = .signIn
                                        self.sUAndLiSegmentedControl.selectedSegmentIndex = 1
                                        self.sUAndLiButton.setTitle("Sign In", for: .normal)
                                    }
                                }
                            }
                        } catch {
                            print("Error signing up: \(error)")
                        }
                    })
                } else {
                    // TODO: Call sign in method on api controller
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
    
    @IBAction func segmentedTypeChange(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            loginType = .signUp
                sUAndLiButton.setTitle("Sign Up", for: .normal)
            } else {
                loginType = .signIn
                sUAndLiButton.setTitle("Sign In", for: .normal)
        }
    }
}
