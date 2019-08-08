//
//  LoginViewController.swift
//  Gigs
//
//  Created by Alex Shillingford on 8/7/19.
//  Copyright © 2019 Alex Shillingford. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case logIn
}

class LoginViewController: UIViewController {
    
    @IBOutlet weak var segmentLoginControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var gigController: GigController!
    var loginType: LoginType = .signUp
    

    override func viewDidLoad() {
        super.viewDidLoad()

        loginButton.layer.cornerRadius = 8.0
    }
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        if segmentLoginControl.selectedSegmentIndex == 0 {
            loginButton.setTitle("Sign Up", for: .normal)
            loginType = .signUp
        } else {
            loginButton.setTitle("Sign In", for: .normal)
            loginType = .logIn
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard let username = usernameTextField.text, !username.isEmpty,
            let password = passwordTextField.text, !password.isEmpty else { return }
        let user = User(username: username, password: password)
        if loginType == .signUp {
            gigController.signUp(with: user) { (error) in
                if let error = error {
                    print("An error occured during Sign Up: \(error)")
                } else {
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: "Sign up Successful!", message: "Now please log in.", preferredStyle: .alert)
                        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                        alertController.addAction(alertAction)
                        self.present(alertController, animated: true, completion: {
                            self.loginType = .logIn
                            self.segmentLoginControl.selectedSegmentIndex = 1
                            self.loginButton.setTitle("Sign In", for: .normal)
                        })
                    }
                }
            }
        } else {
            gigController.logIn(with: user) { (error) in
                if let error = error {
                    print("An error occured during logIn: \(error)")
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
