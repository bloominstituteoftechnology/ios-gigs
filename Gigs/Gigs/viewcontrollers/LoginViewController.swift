//
//  LoginViewController.swift
//  Gigs
//
//  Created by Vincent Hoang on 5/5/20.
//  Copyright © 2020 Vincent Hoang. All rights reserved.
//

import UIKit
import os.log

protocol LoginDelegate {
    func loginAuthenticated()
}

class LoginViewController: UIViewController {

    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var signupButton: UIButton!
    
    var gigsController: GigController?
    
    var loginDelegate: LoginDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.

    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            signupButton.setTitle("Sign Up", for: .normal)
        } else if sender.selectedSegmentIndex == 1 {
            signupButton.setTitle("Sign In", for: .normal)
        }
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        if checkUsernameNotEmpty() {
            if checkPasswordNotEmpty(){
                let user = User(username: usernameTextField.text!, password: passwordTextField.text!)
                
                let buttonMode = segmentedControl.selectedSegmentIndex
                
                if buttonMode == 0 {
                    gigsController?.signUp(with: user, completion: { result in
                        
                        do {
                            let success = try result.get()
                            if success {
                                os_log("Signed in successfully", log: OSLog.default, type: .debug)

                                DispatchQueue.main.async {
                                    self.generateAlert(title: "Sign Up Successful", message: "Now please log in.")
                                }
                            }
                        } catch {
                            os_log("Error while signing up user: %@", log: OSLog.default, type: .error, "\(error)")
                            return
                        }
                    })
                } else {
                    gigsController?.signIn(with: user, completion: { result in
                        
                        do {
                            let success = try result.get()
                            if success {
                                DispatchQueue.main.async {
                                    self.loginDelegate?.loginAuthenticated()
                                    self.dismiss(animated: true, completion: nil)
                                }
                            }
                        } catch {
                            if let error = error as? GigController.NetworkError {
                                switch error {
                                case .failedSignIn:
                                    os_log("Sign in failed", log: OSLog.default, type: .error)
                                    
                                    DispatchQueue.main.async {
                                        self.generateAlert(title: "Sign in failed.", message: "The username and/or password provided was incorrect.")
                                    }
                                case .noData, .noToken:
                                    os_log("No data received", log: OSLog.default, type: .error)
                                default:
                                    os_log("Unknown error occured", log: OSLog.default, type: .error)
                                }
                            }
                        }
                    })
                }
            }
        }
    }
    
    private func checkUsernameNotEmpty() -> Bool {
        let username = usernameTextField.text ?? ""
        
        if username.isEmpty {
            generateAlert(title: "Error", message: "Username field must not be empty!")
            
            return false
        }
        
        return true
    }
    
    private func checkPasswordNotEmpty() -> Bool {
        let password = passwordTextField.text ?? ""
        
        if password.isEmpty {
            generateAlert(title: "Error", message: "Password field must not be empty!")
            
            return false
        }
        
        return true
    }
    
    private func checkPasswordRegex() {
        
    }
    
    private func generateAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        present(alert, animated: true)
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
