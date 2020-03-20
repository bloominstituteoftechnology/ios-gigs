//
//  LoginViewController.swift
//  Gigs
//
//  Created by Elizabeth Thomas on 3/17/20.
//  Copyright © 2020 Libby Thomas. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case signIn
}

class LoginViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var loginTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    // MARK: - Public Properties
    var gigController: GigController?
    var loginType = LoginType.signUp
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
         super.viewDidLoad()

         signInButton.backgroundColor = UIColor(hue: 190/360, saturation: 70/100, brightness: 80/100, alpha: 1.0)
         signInButton.tintColor = .white
         signInButton.layer.cornerRadius = 8.0
     }
    
    // MARK: - IBActions
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        guard let gigController = gigController else { return }
        
        guard let username = usernameTextField.text,
            username.isEmpty == false,
            let password = passwordTextField.text,
            password.isEmpty == false else {
                return
        }
        
        let user = User(username: username, password: password)
        
        switch loginType {
        case .signUp:
            gigController.signUp(with: user) { (error) in
                guard error == nil else {
                    print("Error signing up: \(error!)")
                    return
                }
                
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "Sign Up Successful", message: "Now please log in.", preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(alertAction)
                    
                    self.present(alertController, animated: true) {
                        self.loginType = .signIn                        
                        self.loginTypeSegmentedControl.selectedSegmentIndex = 1
                        self.signInButton.setTitle("Sign In", for: .normal)
                    }
                }
            }
        case .signIn:
            gigController.signIn(with: user) { (error) in
                guard error == nil else {
                    print("Error logging in: \(error!)")
                    return
                }
                
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func loginTypeChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            loginType = .signUp
            signInButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .signIn
            signInButton.setTitle("Sign In", for: .normal)
        }
    }
}
