//
//  LoginViewController.swift
//  Gigs
//
//  Created by brian vilchez on 9/4/19.
//  Copyright © 2019 brian vilchez. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case signIn
}


class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    // MARK: - Outlets
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signUpOrLogin: UISegmentedControl!
    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    // MARK: - properties
    var gigController: GigController?
    var loginType = LoginType.signUp
    // MARK: - Actions
    
    @IBAction func signUpButton(_ sender: UIButton) {
        guard let userName = usernameTextfield.text, let password = passwordTextfield.text,
            !password.isEmpty,!userName.isEmpty else {return}
        
        let user = User(username: userName, password: password)
        
        if loginType == .signUp {
            gigController?.signUp(with: user, completion: { (NetworkError) in
                if let error = NetworkError {
                    NSLog("error occured during sign up: \(error)")
                } else {
                    
                    let alert = UIAlertController(title: "Sign Up Successful", message: "Now please sign in", preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    
                    alert.addAction(okAction)
                    
                    DispatchQueue.main.async {
                        self.present(alert, animated: true, completion: {
                            self.loginType = .signIn
                            self.signUpOrLogin.selectedSegmentIndex = 1
                            self.signUpButton.setTitle("sign In", for: .normal)
                        })
                    }
                    
                }
                
            })
        } else if loginType == .signIn {
            gigController?.login(with: user, completion: { (network) in
                if let error = network {
                    NSLog("error logging in user: \(error)")
                } else {
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            })
        }
       
    }

    @IBAction func loginTypeSegmentControl(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            loginType = .signUp
            signUpButton.setTitle("sign up", for: .normal)
        } else {
            loginType = .signIn
            signUpButton.setTitle("sign in", for: .normal)
        }
    }
    
}
