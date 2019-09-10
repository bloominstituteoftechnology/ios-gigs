//
//  LoginViewController.swift
//  Gigs
//
//  Created by Fabiola S on 9/10/19.
//  Copyright © 2019 Fabiola Saga. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case signIn
}

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var loginTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var reEnterPasswordLabel: UILabel!
    
    
    var gigController: GigController?
    var loginType = LoginType.signUp
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reEnterPasswordLabel.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        guard let gigController = gigController else { return }
        
        if let username = usernameTextField.text,
            !username.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty,
            let confirmPassword = confirmPasswordTextField.text,
            !confirmPassword.isEmpty {
            
            let user = User(username: username, password: password)
            
            if loginType == .signUp {
                if password != confirmPassword {
                    passwordTextField.shake()
                    confirmPasswordTextField.shake()
                    reEnterPasswordLabel.isHidden = false
                } else {
                gigController.signUP(with: user) { error in
                    if let error = error {
                        print("Error occurred during sign up: \(error)")
                    } else {
                        DispatchQueue.main.async {
                            let alertController = UIAlertController(title: "Sign Up Successful", message: "Now please log in.", preferredStyle: .alert)
                            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alertController.addAction(alertAction)
                            self.present(alertController, animated: true, completion: {
                                self.loginTypeSegmentedControl.selectedSegmentIndex = 1
                                self.loginType = .signIn
                                self.passwordTextField.text = nil
                                self.reEnterPasswordLabel.isHidden = true
                                self.confirmPasswordTextField.isHidden = true
                                self.signInButton.setTitle("Sign In", for: .normal)
                            })
                        }
                        }
                    }
                }
            } else {
                gigController.signIn(with: user) { error in
                    if let error = error {
                        print("Error occured during sign in: \(error)")
                    } else {
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
            
        }
    }
    
    
    @IBAction func signInTypeChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            loginType = .signUp
            passwordTextField.text = nil
            confirmPasswordTextField.text = nil
            confirmPasswordTextField.isHidden = false
            signInButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .signIn
            passwordTextField.text = nil
            reEnterPasswordLabel.isHidden = true
            confirmPasswordTextField.isHidden = true
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

extension UITextField {
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.03
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.fromValue = CGPoint(x: self.center.x - 4.0, y: self.center.y)
        animation.toValue = CGPoint(x: self.center.x + 4.0, y: self.center.y)
        layer.add(animation, forKey: "position")
    }
}
