//
//  LoginViewController.swift
//  iOS-Gigs
//
//  Created by Kat Milton on 7/10/19.
//  Copyright © 2019 Kat Milton. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case signIn
}

class LoginViewController: UIViewController {
    
    @IBOutlet var signInTypeSegmentedControl: UISegmentedControl!
    @IBOutlet var signInButton: UIButton!
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    var gigController: GigController!
    var loginType = LoginType.signUp

    override func viewDidLoad() {
        super.viewDidLoad()
        
        signInButton.layer.cornerRadius = 7.0
        signInButton.setTitle("Sign Up", for: .normal)
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        guard let gigController = gigController else { return }
        if let username = usernameTextField.text,
            !username.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty {
            let user = User(username: username, password: password)
            if loginType == .signUp {
                gigController.signUp(with: user) { error in
                    if let error = error {
                        print("Error occurred during sign up: \(error)")
                    } else {
                        DispatchQueue.main.async {
                            let alertController = UIAlertController(title: "Sign up successful!", message: "Now please log in.", preferredStyle: .alert)
                            let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                            alertController.addAction(alertAction)
                            self.present(alertController, animated: true, completion: {
                                self.loginType = .signIn
                                self.signInTypeSegmentedControl.selectedSegmentIndex = 1
                                self.signInButton.setTitle("Sign In", for: .normal)
                            })
                        }
                    }
                }
            } else {
                gigController.signIn(with: user) { error in
                    if let error = error {
                        print("Error occurred during sign up: \(error)")
                    } else {
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    
    }
//        if let username = usernameTextField.text,
//            !username.isEmpty,
//            let password = passwordTextField.text,
//            !password.isEmpty {
//
//            let user = User(username: username, password: password)
//
//            switch loginType {
//            case .signUp:
//                signUp(with: user)
//            case .signIn:
//                signIn(with: user)
//            }
//        }
    
    
    @IBAction func signInSegmentChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            loginType = .signUp
            signInButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .signIn
            signInButton.setTitle("Sign In", for: .normal)
        }
    }
    
//    private func signUp(with user: User) {
//        gigController?.signUp(with: user, completion: { (error) in
//            if let error = error {
//                NSLog("Error during signup process: \(error)")
//            } else {
//                DispatchQueue.main.async {
//                    let alert = UIAlertController(title: "Sign up successful!", message: "Now please sign in.", preferredStyle: .alert)
//                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//                    alert.addAction(okAction)
//                    self.present(alert, animated: true, completion: {
//                        self.loginType = .signIn
//                        self.signInTypeSegmentedControl.selectedSegmentIndex = 1
//                        self.signInButton.setTitle("Sign In", for: .normal)
//                    })
//                }
//            }
//        })
//    }
//
//
//    private func signIn(with user: User) {
//        gigController?.signIn(with: user, completion: { (error) in
//            if let error = error {
//                NSLog("Error occurred during sign in: \(error)")
//            } else {
//                DispatchQueue.main.async {
//                    self.dismiss(animated: true, completion: nil)
//                }
//            }
//        })
//    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
