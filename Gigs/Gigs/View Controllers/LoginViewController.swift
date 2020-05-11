//
//  LoginViewController.swift
//  Gigs
//
//  Created by Ahava on 5/8/20.
//  Copyright © 2020 Ahava. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    enum LoginType {
        case login
        case signUp
    }

    @IBOutlet weak var loginSegmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var gigController: GigController?
    var loginType: LoginType = .signUp
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginSegmentControlChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            loginType = .signUp
            loginButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .login
            loginButton.setTitle("Log In", for: .normal)
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        if loginType == .signUp,
            let username = usernameTextField.text,
            let password = passwordTextField.text,
            !username.isEmpty,
            !password.isEmpty {
            gigController?.signUp(with: User(username: username, password: password)) { (error) in
                if let error = error {
                    NSLog("Error occurred during sign up: \(error)")
                } else {
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: "Sign Up Successful", message: "Now please log in.", preferredStyle: .alert)
                        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(alertAction)
                        self.present(alertController, animated: true) {
                            self.loginSegmentedControl.selectedSegmentIndex = 1
                            self.loginType = .login
                            self.loginButton.setTitle("Sign In", for: .normal)
                        }
                    }
                }
            }
        } else if let username = usernameTextField.text,
            let password = passwordTextField.text,
            !username.isEmpty,
            !password.isEmpty {
            gigController?.login(with: User(username: username, password: password)) { (error) in
                if let error = error {
                    NSLog("Error occurred during sign up: \(error)")
                } else {
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
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
