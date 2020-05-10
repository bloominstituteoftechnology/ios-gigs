//
//  LoginViewController.swift
//  Gigs
//
//  Created by Kenneth Jones on 5/10/20.
//  Copyright © 2020 Kenneth Jones. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case signIn
}

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var signUpLogInControl: UISegmentedControl!
    @IBOutlet weak var signUpLogInButton: UIButton!
    
    var gigController: GigController?
    var loginType = LoginType.signUp
    
    override func viewDidLoad() {
        super.viewDidLoad()

        signUpLogInButton.backgroundColor = UIColor(hue: 190/360, saturation: 70/100, brightness: 80/100, alpha: 1.0)
        signUpLogInButton.tintColor = .white
        signUpLogInButton.layer.cornerRadius = 8.0
    }
    
    @IBAction func signUpLogInChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            loginType = .signUp
            signUpLogInButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .signIn
            signUpLogInButton.setTitle("Log In", for: .normal)
        }
    }
    
    @IBAction func signUpLogInTapped(_ sender: UIButton) {
        if let username = userTextField.text,
            !username.isEmpty,
            let password = passTextField.text,
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
                                    self.signUpLogInControl.selectedSegmentIndex = 1
                                    self.signUpLogInButton.setTitle("Sign In", for: .normal)
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
