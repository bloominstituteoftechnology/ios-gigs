//
//  LoginViewController.swift
//  Gigs
//
//  Created by Eoin Lavery on 11/09/2019.
//  Copyright © 2019 Eoin Lavery. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case signIn
}

class LoginViewController: UIViewController {

    //MARK: - IBOutlets for UIKit elements
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var actionModeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var actionButton: UIButton!
    
    //MARK: - Properties
    var gigController: GigController?
    var loginType = LoginType.signUp
    
    //MARK: - View Lifecycle / viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        actionButton.layer.cornerRadius = 8.0

        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    //MARK: - IBActions for UIKit Elements
    @IBAction func actionModeValueDidChange(_ sender: Any) {
        if actionModeSegmentedControl.selectedSegmentIndex == 0 {
            loginType = .signUp
            actionButton.setTitle("SIGN UP", for: .normal)
        } else {
            loginType = .signIn
            actionButton.setTitle("SIGN IN", for: .normal)
        }
    }
    
    @IBAction func actionButtonTapped(_ sender: Any) {
        guard let gigController = gigController else { return }
        
        if let username = emailTextField.text,
            let password = passwordTextField.text,
            !username.isEmpty,
            !password.isEmpty {
        
        let user = User(username: username, password: password)
        
        if loginType == .signUp {
            gigController.signUp(for: user) { error in
                if let error = error {
                    print("Error occured whilst signing up: \(error)")
                } else {
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: "Sign Up Successful", message: "Your new account has been created. Please Sign In.", preferredStyle: .alert)
                        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                        alertController.addAction(alertAction)
                        self.present(alertController, animated: true, completion: {
                            self.actionModeSegmentedControl.selectedSegmentIndex = 1
                            self.loginType = .signIn
                            self.actionButton.setTitle("SIGN IN", for: .normal)
                        })
                    }
                }
            }
        } else if loginType == .signIn {
            gigController.signIn(for: user) { error in
                if let error = error {
                    print("Error occured whilst attempting to Sign In: \(error)")
                } else {
                    print("Login Successful...")
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    }
}

//MARK: - Extension to class with reference to UITextField Delegate
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
