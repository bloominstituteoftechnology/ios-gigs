//
//  LoginViewController.swift
//  gigs
//
//  Created by Ian French on 5/10/20.
//  Copyright © 2020 Ian French. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case signIn
}


class LoginViewController: UIViewController, UITextFieldDelegate {
    
    
    
    
    @IBOutlet weak var signupSegmented: UISegmentedControl!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signupButton: UIButton!
    
    var gigController: GigController?
    var loginType = LoginType.signUp
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signupButton.backgroundColor = UIColor.systemBlue
        signupButton.tintColor = .white
        signupButton.layer.cornerRadius = 8.0
        
        signupSegmented.setTitleTextAttributes ([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.normal)
        signupSegmented.setTitleTextAttributes ([NSAttributedString.Key.foregroundColor: UIColor.systemBlue], for: UIControl.State.selected)
        signupSegmented.backgroundColor = UIColor.systemBlue
        signupSegmented.tintColor = .white
        signupSegmented.layer.cornerRadius = 8.0
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func segmentAction(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            loginType = .signUp
            signupButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .signIn
            signupButton.setTitle("Sign In", for: .normal)
        }
    }
    
    
    @IBAction func buttonAction(_ sender: UIButton) {
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
                                let alertController = UIAlertController(title: "Sign Up Successful", message: "Now please log in.", preferredStyle: .alert)
                                let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                                alertController.addAction(alertAction)
                                self.present(alertController, animated: true) {
                                    self.loginType = .signIn
                                    self.signupSegmented.selectedSegmentIndex = 1
                                    self.signupButton.setTitle("Sign In", for: .normal)
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
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
