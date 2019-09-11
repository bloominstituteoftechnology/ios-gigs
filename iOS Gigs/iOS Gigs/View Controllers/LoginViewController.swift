//
//  LoginViewController.swift
//  iOS Gigs
//
//  Created by Vici Shaweddy on 9/10/19.
//  Copyright © 2019 Vici Shaweddy. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case logIn
}

class LoginViewController: UIViewController {
    @IBOutlet weak var loginTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    var gigController: GigController?
    
    var loginType = LoginType.signUp
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.signInButton.backgroundColor = UIColor(hue: 190/360, saturation: 70/100, brightness: 80/100, alpha: 1)
        self.signInButton.tintColor = .white
        self.signInButton.layer.cornerRadius = 8.0

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signInTypeChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            loginType = .signUp
            signInButton.setTitle("Sign Up", for: .normal)
        } else if sender.selectedSegmentIndex == 1 {
            loginType = .signUp
            signInButton.setTitle("Log In", for: .normal)
        }
        
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        guard let gigController = gigController else { return }
        
        if let username = usernameTextField.text,
               !username.isEmpty,
           let password = passwordTextField.text,
               !password.isEmpty {
            
            print(username)
            let user = User(username: username, password: password)
            
            if loginType == .signUp {
                gigController.signUp(with: user) { (error) in
                    if let error = error {
                        print("Error occur during sign up: \(error)")
                    } else {
                        DispatchQueue.main.async {
                            let alertController = UIAlertController(title: "Sign Up Successful", message: "You can log in now", preferredStyle: .alert)
                            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            
                            alertController.addAction(alertAction)
                            self.present(alertController, animated: true, completion: {
                                self.loginTypeSegmentedControl.selectedSegmentIndex = 1
                                self.loginType = .logIn
                                self.signInButton.setTitle("Log In", for: .normal)
                            })
                        }
                    }
                }
            } else if loginType == .logIn {
                gigController.logIn(with: user) { (error) in
                    if let error = error {
                        print("Error occur during sign in: \(error)")
                    } else {
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
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
