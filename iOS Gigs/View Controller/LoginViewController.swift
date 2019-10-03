//
//  LoginViewController.swift
//  iOS Gigs
//
//  Created by Andrew Ruiz on 10/2/19.
//  Copyright © 2019 Andrew Ruiz. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case LogIn
}

class LoginViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpLoginButton: UIButton!
    
    
    var gigController: GigController!
    var loginType: LoginType = .signUp
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func signUpLoginButtonTapped(_ sender: Any) {
        
        // Creating a user
        
        guard let username = usernameTextField.text,
            let password = passwordTextField.text,
            username != "",
            !password.isEmpty else { return }
        
        let user = User(username: username, password: password)
        
        if loginType == .signUp {
            gigController.signUp(with: user, completion: { (error) in
                
                if let error = error {
                    NSLog("Error occurred during sign up: \(error)")
                } else {
                    let alert = UIAlertController(title: "Sign Up Successful",
                                                  message: "Now please log in",
                                                  preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    
                    alert.addAction(okAction)
                    
                    DispatchQueue.main.async {
                        self.present(alert, animated: true) {
                            self.loginType = .LogIn
                            self.segmentedControl.selectedSegmentIndex = 1
                            self.signUpLoginButton.setTitle("Sign In", for: .normal)
                        }
                    }
                }
            })
        } else {
            gigController.signIn(with: user) { (error) in
                if let error = error {
                    NSLog("Error occurred during sign in: \(error)")
                } else {
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    @IBAction func segmentedControlTapped(_ sender: Any) {
        
        if segmentedControl.selectedSegmentIndex == 0 {
            loginType = .signUp
            signUpLoginButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .LogIn
            signUpLoginButton.setTitle("Login", for: .normal)
        }
    }
    
}
