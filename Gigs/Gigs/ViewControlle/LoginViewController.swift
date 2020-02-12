//
//  LoginViewController.swift
//  Gigs
//
//  Created by Ufuk Türközü on 15.01.20.
//  Copyright © 2020 Ufuk Türközü. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case signIn
}

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginTypeSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var signInButton: UIButton!
    
    var loginType = LoginType.signUp
    var gigController: GigController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        signInButton.backgroundColor = UIColor(hue: 190/360, saturation: 70/100, brightness: 80/100, alpha: 1.0)
        signInButton.tintColor = .white
        signInButton.layer.cornerRadius = 8.0
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        
        guard let username = usernameTextField.text,
            let password = passwordTextField.text,
            !username.isEmpty,
            !password.isEmpty else { return }
              
        let user = User(username: username, password: password)
        
        if loginType == .signUp {
            signUp(with: user)
        } else {
            signIn(with: user)
        }
    }
    
    func signUp(with user: User) {
        gigController?.signUp(with: user, completion: { (error) in
            if let error = error {
                NSLog("Error during sign up. \(error)")
            } else {
                let alert = UIAlertController(title: "Sign Up Successful", message: "Now please log in", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                alert.addAction(okAction)
                DispatchQueue.main.sync {
                        self.present(alert, animated: true) {
                        self.loginType = .signIn
                        self.loginTypeSegmentedControl.selectedSegmentIndex = 1
                        self.signInButton.setTitle("Sign In", for: .normal)
                    }
                }
            }
        })
    }
    
    func signIn(with user: User) {
        gigController?.signIn(with: user, completion: { (error) in
            if let error = error {
                NSLog("Error during sign in: \(error)")
            } else {
                DispatchQueue.main.sync {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        })
    }
    
    @IBAction func signInTypeChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            loginType = .signUp
            signInButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .signIn
            signInButton.setTitle("Sign In", for: .normal)
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
