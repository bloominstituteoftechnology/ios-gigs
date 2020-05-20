//
//  LoginViewController.swift
//  Gigs
//
//  Created by Kobe McKee on 5/16/19.
//  Copyright © 2019 Kobe McKee. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var gigController: GigController!
    
    var loginType: LoginType = .signUp
    
    
    enum LoginType {
        case logIn
        case signUp
    }
    

    @IBOutlet weak var entryMethodSegmentedControl: UISegmentedControl!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    
    
    @IBAction func entryMethodChanged(_ sender: UISegmentedControl) {
        if entryMethodSegmentedControl.selectedSegmentIndex == 0 {
            loginType = .signUp
            enterButton.setTitle("Sign Up", for: .normal)
            navigationItem.title = "Sign Up"
        } else {
            loginType = .logIn
            enterButton.setTitle("Log In", for: .normal)
            navigationItem.title = "Log In"
        }
    }
    

    @IBAction func enterButtonPressed(_ sender: UIButton) {
        
        guard let username = nameTextField.text,
            let password = passwordTextField.text else { return }
        
        
        if loginType == .signUp {
            gigController.signUp(with: username, password: password, completion: { (error) in
                if let error = error {
                    NSLog("Error signing up \(error)")
                } else {
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: "Sign up Successful", message: "Now please log in.", preferredStyle: .alert)
                        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(alertAction)
                        self.present(alertController, animated: true, completion: {
                            self.loginType = .logIn
                            self.entryMethodSegmentedControl.selectedSegmentIndex = 1
                            self.enterButton.setTitle("Sign In", for: .normal)
                        })
                    }
                }
            })
        } else {
            gigController.logIn(with: username, password: password) { (error) in
                
                if let error = error {
                    NSLog("Error logging in: \(error)")
                } else {
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
            
        }
        
        
        
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
