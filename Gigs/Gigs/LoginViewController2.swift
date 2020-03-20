//
//  LoginViewController2.swift
//  Gigs
//
//  Created by Lambda_School_Loaner_241 on 3/19/20.
//  Copyright © 2020 Lambda_School_Loaner_241. All rights reserved.
//

import UIKit
enum LoginType {
    case signUp
    case signIn
}

class LoginViewController2: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginSegControl: UISegmentedControl!
    @IBOutlet weak var loginButton: UIButton!
    
    
    var gigController: GigController?
    var loginType = LoginType.signUp
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        guard let gigController = gigController else { return }
        
        guard let username = usernameTextField.text, username.isEmpty == false, let password = passwordTextField.text, password.isEmpty == false else { return }
        let user = User(username: username, password: password)
        switch(loginType) {
        case .signUp:
            gigController.signUp(with: user){(error) in
                guard error == nil else {
                    print("Error signing up: \(error!)")
                    return
                }
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "Sign Up successful", message: "Please log in", preferredStyle: .alert)
                    
                    let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    
                    alertController.addAction(alertAction)
                    
                    self.present(alertController, animated: true) {
                        self.loginType = .signIn
                        self.loginSegControl.selectedSegmentIndex = 1
                        self.loginButton.setTitle("Sign In", for: .normal)
                    }
                }
            }
        case .signIn:
            gigController.signUp(with: user){ (error) in
                guard error == nil else {
                    print("Error loggin in: \(error!)")
                    return
                }
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    
    
    
    @IBAction func loginSegControl(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            loginType = .signUp
            loginButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .signIn
            loginButton.setTitle("Sign In", for: .normal)
        }
    }
}





