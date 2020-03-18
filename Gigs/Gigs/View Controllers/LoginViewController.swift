//
//  LoginViewController.swift
//  Gigs
//
//  Created by Claudia Contreras on 3/17/20.
//  Copyright © 2020 thecoderpilot. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case signIn
}

class LoginViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet var logInSignUpSegmentedControl: UISegmentedControl!
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var logiInSignUpButton: UIButton!
    
    // MARK: - Properties
    
    var gigController: GigController?
    var loginType = LoginType.signUp
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    // MARK: - IBActions
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            loginType = .signUp
            logiInSignUpButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .signIn
            logiInSignUpButton.setTitle("Sign In", for: .normal)
        }
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        guard let gigController = gigController else { return }
        
        guard let username = usernameTextField.text, !username.isEmpty,
            let password = passwordTextField.text, !password.isEmpty else {
                return
        }
        
        let user = User(username: username, password: password)
        
        switch loginType {
        case .signUp:
            gigController.signUp(with: user) { (error) in
                guard error == nil else {
                    print("Error signing up: \(error!)")
                    return
                }
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "Sign Up Successful", message: "Now please log in", preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(alertAction)
                    
                    self.present(alertController, animated: true) {
                        self.loginType = .signIn
                        self.logInSignUpSegmentedControl.selectedSegmentIndex = 1
                        self.logiInSignUpButton.setTitle("Sign In", for: .normal)
                    }
                }
            }
        case .signIn:
            gigController.logIn(with: user) { (error) in
                guard error == nil else {
                    print("Error login in: \(error!)")
                    return
                }
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
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
