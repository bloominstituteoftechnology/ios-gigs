//
//  LoginViewController.swift
//  Gigs
//
//  Created by Nonye on 5/5/20.
//  Copyright © 2020 Nonye Ezekwo. All rights reserved.
//

import UIKit

enum LoginType {
    case signup
    case login
}

class LoginViewController: UIViewController {
    
    var gigController: GigController?
    var loginType = LoginType.signup
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        usernameText.becomeFirstResponder()
    }
    
    //MARK: - OUTLETS
    
    @IBOutlet weak var signUpInSegment: UISegmentedControl!
    @IBOutlet weak var usernameText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    @IBOutlet weak var signUpInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    //MARK: - ACTION : SEGEMENT BUTTON SWITCH
    
    @IBAction func signUpInSegmentTapped(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            //then you'd want them to sign in
            loginType = .signup
            signUpInButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .login
            signUpInButton.setTitle("Sign In", for: .normal)
        }
    }
    
    //MARK: - ACTION : SIGN UP BUTTON TAPPED
    @IBAction func signUpInTapped(_ sender: Any) {
        if let username = usernameText.text,
            !username.isEmpty,
            let password = passwordText.text,
            !password.isEmpty {
            let user = User(username: username, password: password)
            
            if loginType == .signup {
                gigController?.signUp(with: user, completion: { result in
                    do {
                        let success = try result.get()
                        if success {
                            DispatchQueue.main.async {
                                let alertController = UIAlertController(title: "Sign Up Successful", message: "Now please log in", preferredStyle: .alert)
                                let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                alertController.addAction(alertAction)
                                self.present(alertController, animated: true) {
                                    self.loginType = .login
                                    self.signUpInButton.setTitle("Sign In", for: .normal)
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
