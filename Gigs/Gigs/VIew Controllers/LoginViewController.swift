//
//  LoginViewController.swift
//  Gigs
//
//  Created by Jarren Campos on 3/17/20.
//  Copyright © 2020 Jarren Campos. All rights reserved.
//
import Foundation
import UIKit

enum LoginType {
    case signUp
    case signIn
}

class LoginViewController: UIViewController, UITextFieldDelegate {
    //MARK: -IBOutlets
    @IBOutlet var segmentedController: UISegmentedControl!
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginSigninButton: UIButton!
    
    var gigController: GigController?
    var loginType = LoginType.signUp
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    //MARK: - IBActions
    @IBAction func loginSigninButtonAction(_ sender: UIButton) {
        guard let gigController = gigController else { return }
        
        guard let username = usernameTextField.text,
            username.isEmpty == false,
            let password = passwordTextField.text,
            password.isEmpty == false else {
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
                    let alertController = UIAlertController(title: "Sign Up Successful", message: "Now please log in.", preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(alertAction)
                    
                    self.present(alertController, animated: true) {
                        self.loginType = .signIn
                        self.segmentedController.selectedSegmentIndex = 1
                        self.loginSigninButton.setTitle("Sign In", for: .normal)
                    }
                }
            }
        case .signIn:
            gigController.signIn(with: user) { (error) in
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
    @IBAction func segmentedControllerTapped(_ sender: UISegmentedControl) {
            if sender.selectedSegmentIndex == 0 {
                loginType = .signUp
                loginSigninButton.setTitle("Sign Up", for: .normal)
            } else {
                loginType = .signIn
                loginSigninButton.setTitle("Sign In", for: .normal)
            }
        }
    
}
