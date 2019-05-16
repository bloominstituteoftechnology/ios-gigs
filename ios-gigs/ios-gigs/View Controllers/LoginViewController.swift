//
//  LoginViewController.swift
//  ios-gigs
//
//  Created by Ryan Murphy on 5/16/19.
//  Copyright © 2019 Ryan Murphy. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var logInButton: UIButton!
    var gigController: GigController?
    var signInType: SignInType = .signUp
    
    @IBOutlet weak var segmentedControll: UISegmentedControl!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    override func viewDidLoad() {
        
        
        
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func logInButtonPressed(_ sender: Any) {
        guard let username = userNameTextField.text,
            let password = passwordTextField.text else { return }
        
        switch signInType {
            
        case .signUp:
            
            gigController?.signUp(with: username, password: password, completion: { (error) in
                
                if let error = error {
                    NSLog("Error signing up: \(error)")
                } else {
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: "Sign Up Successful", message: "Now please log in.", preferredStyle: .alert)
                        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(alertAction)
                        self.present(alertController, animated: true, completion: {
                            self.signInType = .logIn
                            self.segmentedControll.selectedSegmentIndex = 1
                            self.logInButton.setTitle("Sign In", for: .normal)
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
    @IBAction func segmentedControllPressed(_ sender: Any) {
        if segmentedControll.selectedSegmentIndex == 0 {
            signInType = .signUp
            logInButton.setTitle("Sign Up", for: .normal)
        } else {
            signInType = .logIn
            logInButton.setTitle("Log In", for: .normal)
        }
    }


enum SignInType {
    case signUp
    case logIn
}


}
