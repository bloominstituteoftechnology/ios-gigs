//
//  LoginViewController.swift
//  Gigs
//
//  Created by scott harris on 2/12/20.
//  Copyright © 2020 scott harris. All rights reserved.
//

import UIKit

enum LoginType {
    case signIn
    case signUp
}

class LoginViewController: UIViewController {
    @IBOutlet weak var loginTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    var gigController: GigController!
    
    var loginType: LoginType = .signUp
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signInButton.backgroundColor = UIColor(hue: 190/360, saturation: 70/100, brightness: 80/100, alpha: 1.0)
        signInButton.tintColor = .white
        signInButton.layer.cornerRadius = 8
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
    
    @IBAction func signInTapped(_ sender: UIButton) {
        guard let username = usernameTextField.text, !username.isEmpty,
            let password = passwordTextField.text, !password.isEmpty else { return }
        let user = User(username: username, password: password)
        if loginType == .signUp {
            gigController.signUp(with: user) { (error) in
                if let error = error {
                    NSLog("Error Received from gig controller \(error)")
                }
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "Success", message: "You can now login!", preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "OK", style: .default)
                    alertController.addAction(alertAction)
                    self.present(alertController, animated: true) {
                        self.loginTypeSegmentedControl.selectedSegmentIndex = 1
                        self.loginType = .signIn
                        self.signInButton.setTitle("Sign In", for: .normal)
                    }
                }
            }
        } else {
            gigController.signIn(with: user) { (error) in
                if let error = error {
                    NSLog("Error Received from gig controller \(error)")
                }
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
            
        }
    }
    
}
