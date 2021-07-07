//
//  LoginViewController.swift
//  Gigs
//
//  Created by Thomas Cacciatore on 5/16/19.
//  Copyright © 2019 Thomas Cacciatore. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    var gigController: GigController!
    var loginType: LogInType = .signUp
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    
    
    @IBAction func segmentedControlsChanged(_ sender: Any) {
        if loginSegmentedControls.selectedSegmentIndex == 0 {
            loginType = .signUp
            loginButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .logIn
            loginButton.setTitle("Sign In", for: .normal)
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let username = nameTextField.text,
            let password = passwordTextField.text else { return }
        
        switch loginType {
        case .signUp:
            gigController?.signUp(with: username, password: password, completion: { (error) in
                if let error = error {
                    NSLog("Error signing up: \(error)")
                } else {
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: "Sign up successful", message: "Now please log in", preferredStyle: .alert)
                        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(alertAction)
                        self.present(alertController, animated: true, completion: {
                            self.loginType = .logIn
                            self.loginSegmentedControls.selectedSegmentIndex = 1
                            self.loginButton.setTitle("Sign In", for: .normal)
                        })
                    }
                }
            })
        
        case .logIn:
            
            gigController?.logIn(with: username, password: password, completion: { (error) in
                if let error = error {
                    NSLog("Error logging in: \(error)")
                } else {
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            })
        }
    }
    
    
    
    
    
   
    @IBOutlet weak var loginSegmentedControls: UISegmentedControl!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    enum LogInType {
        case signUp
        case logIn
    }

}
