//
//  LoginViewController.swift
//  Gigs
//
//  Created by Wyatt Harrell on 3/11/20.
//  Copyright © 2020 Wyatt Harrell. All rights reserved.
//

import UIKit

enum LoginType {
    case signIn
    case signUp
    
}

class LoginViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    
    var gigController: GigController?
    var loginType: LoginType = .signUp
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            loginType = .signUp
            continueButton.setTitle("Sign Up", for: .normal)
        }else {
            loginType = .signIn
            continueButton.setTitle("Log In", for: .normal)
        }
    }
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        guard let username = usernameTextField.text, !username.isEmpty, let password = passwordTextField.text, !password.isEmpty else { return }
        let user = User(username: username, password: password)
        
        if loginType == .signUp {
            
            gigController?.signUp(with: user, completion: { (error) in
                if let error = error {
                    NSLog("Error occured during signup \(error)")
                } else {
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: "Sign Up Successful", message: "Now please sign in.", preferredStyle: .alert)
                        let alertAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
                        alertController.addAction(alertAction)
                        self.present(alertController, animated: true) {
                            self.loginType = .signIn
                            self.segmentedControl.selectedSegmentIndex = 1
                            self.continueButton.setTitle("Sign In", for: .normal)
                        }
                    }
                }
            })
        } else {
            gigController?.signIn(with: user, completion: { (error) in
                if let error = error {
                    NSLog("Error occurred during sign in: \(error)")
                } else {
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            })
            
        }
    }

}
