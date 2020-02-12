//
//  LoginViewController.swift
//  GigS
//
//  Created by Nick Nguyen on 2/12/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case signIn
}



class LoginViewController: UIViewController , UITextFieldDelegate {

    // MARK: - Properties
    var gigController : GigController?
    
    var loginType = LoginType.signUp
    
    @IBOutlet weak var signInSegment: UISegmentedControl! {
        didSet {
            signInSegment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        }
    }
    
    @IBOutlet weak var usernameTextField: UITextField! {
        didSet {
            usernameTextField.delegate = self
            usernameTextField.becomeFirstResponder()
        }
    }
    
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.delegate = self
        }
    }
    
    
    @IBOutlet weak var signUpButton: UIButton! {
                didSet {
            signUpButton.layer.cornerRadius = 10
        }
    }
    
    // MARK: - App Life Cycle
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
 
    }
 
    
    //MARK: - Actions
    
    
    @IBAction func signUpTapped(_ sender: UIButton) {
        guard let gigController = gigController else { return }
        
        if let username = usernameTextField.text, !username.isEmpty,
            let password = passwordTextField.text, !password.isEmpty {
            let user = User(username: username, password: password)
            if loginType == .signUp {
                gigController.signUp(with: user) { (error) in
                    if let error = error {
                        NSLog("Error occurred during sign up : \(error)")
                    } else {
                        DispatchQueue.main.async {
                            let ac = UIAlertController(title: "Sign up succesful", message: "Please log in.", preferredStyle: .alert)
                            ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                            self.present(ac, animated: true) {
                                self.loginType = .signIn
                                self.signInSegment.selectedSegmentIndex = 1
                                self.signUpButton.setTitle("Sign In", for: .normal)
                            }
                        }
                    }
                }
            }
            else {
                gigController.signIn(with: user) { (error) in
                    if let error = error {
                        NSLog("Error signing in: \(error.localizedDescription)")
                    } else {
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
                
            }
            
        }
        
    }
    
    
    
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
         
            loginType = .signUp
            signUpButton.setTitle("Sign Up", for: .normal)
        } else {
         
            loginType = .signIn
            signUpButton.setTitle("Sign In", for: .normal)
        }
        
        
        
        
        
    }
    
    
    
    
    
   
    
}
