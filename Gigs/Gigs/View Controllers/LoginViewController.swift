//
//  LoginViewController.swift
//  Gigs
//
//  Created by Rob Vance on 5/8/20.
//  Copyright © 2020 Robs Creations. All rights reserved.
//

import UIKit

enum LoginType {
    case signIn
    case signUp
}


class LoginViewController: UIViewController {
    
    // Mark: IBOutlets
    @IBOutlet weak var loginTypeSegmentControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
    super.viewDidLoad()
        signInButton.layer.cornerRadius = 8.0
        
    }
    
    var gigController: GigController?
    var loginType = LoginType.signUp
    
    // Mark: IBActions
    @IBAction func signInTypeChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            loginType = .signUp
            signInButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .signIn
            signInButton.setTitle("Sign In", for: .normal)
        }
    }
    @IBAction func loginTapped(_ sender: Any) {
        if let username = usernameTextField.text , !username.isEmpty,
            let password = passwordTextField.text, !password.isEmpty{
            let user = User(username: username, password: password)
            if loginType == .signUp {
                gigController?.signUp(with: user, completion: { (result) in
                    do{
                        let success = try result.get()
                        if success{
                            DispatchQueue.main.async {
                                let alertController = UIAlertController(title: "Sign Up Successful", message: "Now please log in", preferredStyle: .alert)
                                let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                                alertController.addAction(alertAction)
                                self.present(alertController, animated: true) {
                                    self.loginType = .signIn
                                    self.loginTypeSegmentControl.selectedSegmentIndex = 1
                                    self.signInButton.setTitle("Sign In", for: .normal)
                                }
                                
                            }
                        }
                    } catch {
                        print("Error signing up: \(error)")
                    }
                })
            } else {
                gigController?.signIn(with: user, completion: { (result) in
                    do{
                        let success = try result.get()
                        if success{
                            DispatchQueue.main.async {
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                    } catch {
                        if let error = error as? GigController.NetworkError{
                            switch error {
                            case .failedSignIn:
                                print("Sign in failed")
                            case .noData, .noToken:
                                print("No data recieved")
                            default:
                                print("Other error occured")
                            }
                        }
                    }
                })
            }
        }
    }
}

    



    


