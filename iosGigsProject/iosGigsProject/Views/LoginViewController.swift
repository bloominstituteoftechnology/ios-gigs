//
//  LoginViewController.swift
//  iosGigsProject
//
//  Created by B$hady on 7/12/20.
//  Copyright © 2020 Lambda. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    enum LoginType {
        case signUp
        case signIn
    }
    
    var gigController: GigController?
    var loginType = LoginType.signUp
    
    @IBOutlet weak var segmentedController: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInLogInButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        signInLogInButton.layer.cornerRadius = 8
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signInLogInSegmentedControl(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            loginType = .signUp
            signInLogInButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .signIn
            signInLogInButton.setTitle("Sign In", for: .normal)
        }
    }
    
    
    @IBAction func signInLogInButtonTapped(_ sender: Any) {
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
                                                self.segmentedController.selectedSegmentIndex = 1
                                                self.signInLogInButton.setTitle("Sign In", for: .normal)
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
                                        case .nodata, .noToken:
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


