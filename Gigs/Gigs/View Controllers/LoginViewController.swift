//
//  LoginViewController.swift
//  Gigs
//
//  Created by Lambda_School_Loaner_204 on 10/30/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case signIn
}

class LoginViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpInSegementedControl: UISegmentedControl!
    
    // MARK: - Properties
    var gigController: GigController!
    var loginType = LoginType.signUp
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        signInButton.layer.cornerRadius = 8.0
        passwordTextField.isSecureTextEntry = true
    }
    
    // Function that converts the password if secureTextEntry for text field is on
    private func passwordTextFieldSecureString(_ password: String) -> String {
        if passwordTextField.isSecureTextEntry {
            passwordTextField.attributedText = NSAttributedString(string: password)
            return passwordTextField.attributedText?.string ?? ""
        } else {
            return password
        }
    }
    
    @IBAction func signInChanged(_ sender: UISegmentedControl) {
        
        if signUpInSegementedControl.selectedSegmentIndex == 0 {
            loginType = .signUp
            signInButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .signIn
            signInButton.setTitle("Sign In", for: .normal)
        }
    }
    
    @IBAction func logInButtonTapped(_ sender: UIButton) {
        guard let gigController = gigController else { return }
        guard let usernameText = usernameTextField.text,
            !usernameText.isEmpty,
            let passwordText = passwordTextField.text,
            !passwordText.isEmpty else { return }
        
        let password = passwordTextFieldSecureString(passwordText)
        let user = User(username: usernameText, password: password)
        
        if loginType == .signUp {
            gigController.signUp(with: user) { error in
                if let error = error {
                    print("Error occurred during sign up: \(error)")
                } else {
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: "Sign Up Successful", message: "Now please sign in.", preferredStyle: .alert)
                        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(alertAction)
                        self.present(alertController, animated: true) {
                            self.loginType = .signIn
                            self.signUpInSegementedControl.selectedSegmentIndex = 1
                            self.signInButton.setTitle("Sign In", for: .normal)
                        }
                    }
                }
            }
        } else {
            gigController.signIn(with: user) { error in
                if let error = error {
                    print("Error occurred during sign in: \(error)")
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
