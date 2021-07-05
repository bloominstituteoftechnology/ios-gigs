//
//  LoginViewController.swift
//  ios-gigs
//
//  Created by admin on 9/4/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case signIn
}

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginSegmentControl: UISegmentedControl!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var buttonText: UIButton!
    
    var gigController: GigController!
    
    var loginType = LoginType.signUp
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func segmentControlTapped(_ sender: UIButton) {
        
        guard let username = userNameTextField.text,
            let password = passwordTextField.text,
            !username.isEmpty,
            !password.isEmpty else { return }
        
        let user = User(username: username, password: password)
        
        if loginType == .signIn {
            
            gigController?.signUp(with: user, completion: { (networkError) in
                
                if let error = networkError {
                    
                    NSLog("Error occured during signup: \(error)")
                
                } else {
                    
                    let alert = UIAlertController(title: "Signup successful!", message: "Please sign in.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    
                    alert.addAction(okAction)
                    
                    DispatchQueue.main.async {
                        self.present(alert, animated: true, completion: {
                            self.loginType = .signIn
                            self.loginSegmentControl.selectedSegmentIndex = 1
                            self.buttonText.setTitle("Sign In", for: .normal)})
                    }
                }
                
            })
        } else if loginType == .signIn {
            gigController?.loginURL(with: user, completion: { (networkError) in
                if let error = networkError {
                    NSLog("Error occured during login: \(error)")
                } else {
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            })
        }
    }
    
    @IBAction func buttonTapped(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            loginType = .signUp
            buttonText.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .signIn
            buttonText.setTitle("Sign In", for: .normal)
        }
    }

}
