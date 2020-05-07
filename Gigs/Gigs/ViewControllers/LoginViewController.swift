//
//  LoginViewController.swift
//  Gigs
//
//  Created by Marissa Gonzales on 5/5/20.
//  Copyright © 2020 Joe Veverka. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController {
    // Outlets
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var signInButtonOutlet: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    
    enum LoginType {
        case signIn
        case signUp
    }
    var loginType = LoginType.signUp
    var gigController: GigController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signInButtonOutlet.tintColor = .blue
        signInButtonOutlet.layer.cornerRadius = 8.0
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        userNameTextField.becomeFirstResponder()
    }
    // Actions
    @IBAction func segmentedControlAction(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            loginType = .signUp
            signInButtonOutlet.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .signIn
            signInButtonOutlet.setTitle("Sign In", for: .normal)
        }
    }
    @IBAction func signInButtonAction(_ sender: Any) {
        
        // unwrap text fields - 4 part if let.
        if let username = userNameTextField.text,
            !username.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty {
            let user = User(username: username, password: password)
            
            if loginType == .signUp {
                gigController?.signUp(with: user, completion: { result in
                    do {
                        let success = try result.get()
                        if success {
                            DispatchQueue.main.async {
                                let alertController = UIAlertController(title: "Sign Up Successful", message: "Now Please Login", preferredStyle: .alert)
                                let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                alertController.addAction(alertAction)
                                self.present(alertController, animated: true) {
                                    self.loginType = .signIn
                                    self.segmentedControl.selectedSegmentIndex = 1
                                    self.signInButtonOutlet.setTitle("Sign In", for: .normal)
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
                            case .failedLogin:
                                print("Sign In Failed")
                            case .noToken:
                                print("No data received")
                            default:
                                print("Other errors occured")
                            }
                        }
                    }
                })
            }
        }
    }
}
