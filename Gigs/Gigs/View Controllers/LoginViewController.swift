//
//  LoginViewController.swift
//  Gigs
//
//  Created by Alex Rhodes on 9/4/19.
//  Copyright © 2019 Alex Rhodes. All rights reserved.
//

import UIKit

enum LoginType {
    case login
    case signUp
}

class LoginViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var otherView: UIView!
    
    var gigController: GigController!
    
    var loginType = LoginType.signUp

    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
    }
    
    func setViews() {
        
        passwordTextField.backgroundColor = .gray
        usernameTextField.backgroundColor = .gray
        
        otherView.backgroundColor = #colorLiteral(red: 0.09669762105, green: 0.09793875366, blue: 0.09788999707, alpha: 1)
        
        view.backgroundColor = #colorLiteral(red: 0.09669762105, green: 0.09793875366, blue: 0.09788999707, alpha: 1)
        
        segmentedControl.tintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
        signUpButton.backgroundColor = #colorLiteral(red: 0.3829096258, green: 0.6703189015, blue: 0.6273114681, alpha: 1)
        signUpButton.setTitleColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), for: .normal)
        signUpButton.layer.cornerRadius = 6
        
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        
        guard let username = usernameTextField.text,
            let password = passwordTextField.text, !password.isEmpty, !username.isEmpty else {return}
        
        let user = User(username: username, password: password)
        
        if loginType == .signUp {
            
            gigController?.signUp(with: user, completion: { (networkError) in
                
                if let error = networkError {
                    
                    NSLog("Error occured during signup: \(error)")
                    
                } else {
                    
                    let alert = UIAlertController(title: "Signup successful!", message: "Please sign in.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    
                    alert.addAction(okAction)
                    
                    DispatchQueue.main.async {
                        
                        self.present(alert, animated: true, completion: {
                            
                            self.loginType = .login
                            self.segmentedControl.selectedSegmentIndex = 1
                            self.signUpButton.setTitle("Sign In", for: .normal)})
                    }
                }
            })
            
        } else if loginType == .login {
            
            guard let username = usernameTextField.text,
                let password = passwordTextField.text, !password.isEmpty, !username.isEmpty else {return}
            
            let user = User(username: username, password: password)
            
            gigController?.login(with: user, completion: { (networkError) in
                
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            })
            
            
        }
        
        
    }
    
    @IBAction func signInTypeChanged(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            loginType = .signUp
            signUpButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .login
            signUpButton.setTitle("Sign In", for: .normal)
        }
    }
}
