//
//  LoginViewController.swift
//  Gigs
//
//  Created by Jake Connerly on 6/19/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case logIn
}

class LoginViewController: UIViewController {
    
    //
    //MARK: - Outlets and Properties
    //
    
    @IBOutlet weak var logInSegmentedControl: UISegmentedControl!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    
    var gigController: GigController!
    var loginType = LoginType.signUp
    
    //
    //MARK: - View LifeCycle
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Custom logInButton
        
        logInButton.backgroundColor = UIColor(hue: 140/360, saturation: 75/100, brightness: 50/100, alpha: 1.0)
        logInButton.tintColor = .white
        logInButton.layer.cornerRadius = 8.0
        // Custom segmentedControl
        logInSegmentedControl.backgroundColor = .white
        logInSegmentedControl.tintColor = UIColor(hue: 140/360, saturation: 75/100, brightness: 50/100, alpha: 1.0)
        logInSegmentedControl.layer.cornerRadius = 8.0
        
    }
 
    
    //
    // MARK:- IBActions
    //
    
    @IBAction func logInButtonTapped(_ sender: UIButton) {
        guard let gigController = gigController else { return }
        if let username = userNameTextField.text,
            !username.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty {
            let user = User(username: username, password: password)
            if loginType == .signUp {
                gigController.signUp(with: user) { error in
                    if let error = error {
                        print("Error occured during sign up: \(error)")
                    }else {
                        DispatchQueue.main.async{
                            let alertController = UIAlertController(title: "Sign Up Sucessful", message: "Now please log in", preferredStyle: .alert)
                            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alertController.addAction(alertAction)
                            self.present(alertController, animated: true, completion: {
                                self.loginType = .logIn
                                self.logInSegmentedControl.selectedSegmentIndex = 1
                                self.logInButton.setTitle("Log In", for: .normal)
                            })
                        }
                    }
                }
            }else {
                gigController.logIn(with: user) { error in
                    if let error = error {
                        print("error during sign in: \(error)")
                    }else {
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                            
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func logInSegmentedControlValueChange(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            loginType = .signUp
            logInButton.setTitle("Sign Up", for: .normal)
        }else {
            loginType = .logIn
            logInButton.setTitle("Sign In", for: .normal)
        }
    }
}
