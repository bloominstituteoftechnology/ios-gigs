//
//  LoginViewController.swift
//  Gigs
//
//  Created by Morgan Smith on 1/21/20.
//  Copyright © 2020 Morgan Smith. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case signIn
}

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var loginTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    
    var gigController: GigController?
    var loginType = LoginType.signUp
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signInButton.backgroundColor = UIColor(hue: 190/360, saturation: 70/100, brightness: 80/100, alpha: 1.0)
               signInButton.tintColor = .white
               signInButton.layer.cornerRadius = 8.0

        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        guard let gigController = gigController else {return}
            guard let username = usernameTextField.text, !username.isEmpty, let password = passwordTextField.text, !password.isEmpty else { return }
            
            let user = User(username: username, password: password)
            
            if loginType == .signUp {
                gigController.signUp(with: user) { (error) in
                    if let error = error {
                        print("Error occurred during sign up: \(error)")
                    } else {
                        DispatchQueue.main.async {
                            let alertController = UIAlertController(title: "Sign Up Successful", message: "Now please sign in", preferredStyle: .alert)
                            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alertController.addAction(alertAction)
                            self.present(alertController, animated: true, completion: {
                                self.loginType = .signIn
                                self.loginTypeSegmentedControl.selectedSegmentIndex = 1
                                self.signInButton.setTitle("Sign In", for: .normal)
                            })
                        }
                    }
                }
                
            } else {
                gigController.signIn(with: user) { error in
                    if let error = error {
                        print("Error occurred during sign in: \(error)")
                    } else {
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    
    
    
    @IBAction func signInTypeChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
                 loginType = .signUp
                 signInButton.setTitle("Sign Up", for: .normal)
             } else {
                 loginType = .signIn
                 signInButton.setTitle("Sign In", for: .normal)
             }
    }

}
