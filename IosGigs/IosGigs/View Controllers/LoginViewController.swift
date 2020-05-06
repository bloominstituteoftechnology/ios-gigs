//
//  LoginViewController.swift
//  IosGigs
//
//  Created by Kelson Hartle on 5/5/20.
//  Copyright © 2020 Kelson Hartle. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case signIn
    
}

class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginSignInButton: UIButton!
    
    // MARK: - Properties
    
    var gigController: GigController?
    var loginType = LoginType.signUp
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginSignInButton.backgroundColor = UIColor(hue: 190/360, saturation: 70/110, brightness: 80/100, alpha: 1.0)
        loginSignInButton.tintColor = .black
        loginSignInButton.layer.cornerRadius = 8.0
        
        loginSignInButton.setTitle("Sign Up", for: .normal)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        username.becomeFirstResponder()
    }
    
    // MARK: - Actions

    @IBAction func signInTapped(_ sender: UIButton) {
        if let username = username.text,
            !username.isEmpty,
            let password = password.text,
            !password.isEmpty {
            
            let user = User(username: username, password: password)
            
            if loginType == .signUp {
                
                gigController?.signUP(with: user, completion: { result in
                    do {
                        let success = try result.get()
                        
                        if success {
                            DispatchQueue.main.async {
                                let alertController = UIAlertController(title: "Login Sucessfull", message: "You can sign in", preferredStyle: .alert)
                                let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                alertController.addAction(alertAction)
                                
                                self.present(alertController, animated: true) {
                                    self.loginType = .signIn
                                    self.segmentControl.selectedSegmentIndex = 1
                                    self.loginSignInButton.setTitle("Sign In", for: .normal)
                                }
                            }
                        }
                    } catch {
                        print("Error signing up: \(error)")
                    }
                })
            } else {
                gigController?.signIn(with: user, completion: { result in
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
                            case .noData,.noToken:
                                print("No data receieved")
                            default:
                                print("other error has ocurred")
                            }
                        }
                    }
                })
            }
        }
        
    }
    
    @IBAction func signInTypeChanged(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            
            loginType = .signUp
            loginSignInButton.setTitle("Sign Up", for: .normal)
        } else {
            
            loginType = .signIn
            loginSignInButton.setTitle("Sign In", for: .normal)
        }
    }
}
