//
//  LoginViewController.swift
//  gigsCraigBelinfante
//
//  Created by Craig Belinfante on 7/12/20.
//  Copyright © 2020 Craig Belinfante. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case signIn
}

class LoginViewController: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signUPsignIN: UISegmentedControl!
    @IBOutlet weak var loginButton: UIButton!
    
    var apiController: APIController?
    var loginType = LoginType.signUp
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    //Actions
    @IBAction func buttonTapped(_ sender: Any) {
        if let username = username.text,!username.isEmpty,
            let password = password.text,!username.isEmpty {
            let user = User(username: username, password: password)
            
            switch loginType {
            case .signUp:
                apiController?.signUp(with: user, completion: { (result) in
                    do {
                        let success = try
                            result.get()
                        if success {
                            DispatchQueue.main.async {
                                let alertController = UIAlertController(title: "Sign Up Successful", message: "Now Log In", preferredStyle: .alert)
                                let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                alertController.addAction(alertAction)
                                self.present(alertController, animated: true) {
                                    self.loginType = .signIn
                                    self.signUPsignIN.selectedSegmentIndex = 1
                                    self.loginButton.setTitle("Sign In", for: .normal)
                                }
                            }
                        }
                    } catch {
                        print("Error")
                    }
                })
            case .signIn:
                apiController?.signIn(with: user, completion: { (result) in
                    do {
                        let success = try
                            result.get()
                        if success {
                            DispatchQueue.main.async {
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                    } catch {
                        if let error = error as? APIController.NetworkError {
                            switch error {
                            case .failedSignIn:
                                print("Sign in failed")
                            case .noData, .noToken:
                                print("no data received")
                            default:
                                print("other error occured")
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
            loginButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .signIn
            loginButton.setTitle("Sign In", for: .normal)
        }
    }
}
