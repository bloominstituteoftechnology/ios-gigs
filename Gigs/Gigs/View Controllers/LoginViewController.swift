//
//  LoginViewController.swift
//  Gigs
//
//  Created by Jordan Christensen on 9/5/19.
//  Copyright © 2019 Mazjap Co Technologies. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case signIn
}

class LoginViewController: UIViewController {
    
    var gigController: GigController!
    var loginType = LoginType.signUp
    
    @IBOutlet weak var loginTypesSegmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setColors()
    }
    
    func setColors() {
        view.backgroundColor = UIColor(red: 0.52, green: 0.64, blue: 0.62, alpha: 1.00)
        loginTypesSegmentedControl.tintColor = UIColor(red:0.40, green:0.41, blue:0.39, alpha:1.00)
        usernameTextField.backgroundColor = UIColor(red: 0.40, green: 0.41, blue: 0.39, alpha: 1.00)
        passwordTextField.backgroundColor = UIColor(red: 0.40, green: 0.41, blue: 0.39, alpha: 1.00)
        loginButton.backgroundColor = UIColor(red:0.67, green:0.16, blue:0.25, alpha:1.00)
        
        loginButton.setTitleColor(UIColor(red:0.95, green:0.93, blue:0.93, alpha:1.00), for: .normal)
        loginButton.layer.cornerRadius = 8
        
        usernameTextField.textColor = UIColor(red:0.95, green:0.93, blue:0.93, alpha:1.00)
        usernameTextField.attributedPlaceholder = NSAttributedString(string: "Username:",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(red:0.78, green:0.76, blue:0.76, alpha:1.00)])
        passwordTextField.textColor = UIColor(red:0.95, green:0.93, blue:0.93, alpha:1.00)
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password:",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(red:0.78, green:0.76, blue:0.76, alpha:1.00)])
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        guard let username = usernameTextField.text,
            let password = passwordTextField.text,
            !username.isEmpty,
            !password.isEmpty else { return }
        
        let user = User(username: username, password: password)
        
        if loginType == .signUp {
            
            gigController?.signUp(with: user, completion: { (networkError) in
                
                if let error = networkError {
                    NSLog("Error occurred during sign up: \(error)")
                } else {
                    
                    let alert = UIAlertController(title: "Sign Up Successful", message: "Now please sign in", preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    
                    alert.addAction(okAction)
                    
                    DispatchQueue.main.async {
                        self.present(alert, animated: true, completion: {
                            self.loginType = .signIn
                            self.loginTypesSegmentedControl.selectedSegmentIndex = 1
                            self.loginButton.setTitle("Sign In", for: .normal)
                        })
                    }
                }
            })
            
        } else if loginType == .signIn {
            gigController?.login(with: user, completion: { (networkError) in
                if let error = networkError {
                    NSLog("Error occurred during login: \(error)")
                } else {
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            })
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
