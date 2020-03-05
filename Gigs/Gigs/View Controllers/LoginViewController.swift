//
//  LoginViewController.swift
//  Gigs
//
//  Created by David Wright on 1/20/20.
//  Copyright © 2020 David Wright. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case signIn
}

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var signInButton: UIButton!
    
    var gigController: GigController!
    var loginType = LoginType.signUp
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSignInButton()
        configureLoginTypeSegmentedControl()
    }
    
    // MARK: - Action Handlers
    
    @IBAction func signInTypeChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            loginType = .signUp
            signInButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .signIn
            signInButton.setTitle("Sign In", for: .normal)
        }
    }
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        guard gigController != nil else { return }
        guard let username = usernameTextField.text,
            !username.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty else { return }
        
        let user = User(username: username, password: password)
        
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
                            self.loginTypeSegmentedControl.selectedSegmentIndex = 1
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
    
    // MARK: - Custom UI Settings
    
    private let customColor = #colorLiteral(red: 0.24, green: 0.7066666667, blue: 0.8, alpha: 1) // hue: 190/360, saturation: 0.7, brightness: 0.8, alpha: 1.0
    
    private func configureSignInButton() {
        signInButton.backgroundColor = customColor
        signInButton.tintColor = .white
        signInButton.layer.cornerRadius = 8.0
    }
    
    private func configureLoginTypeSegmentedControl() {
        
        loginTypeSegmentedControl.selectedSegmentTintColor = customColor
        
        let segmentTextAttributes = [NSAttributedString.Key.foregroundColor: customColor]
        let selectedSegmentTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        loginTypeSegmentedControl.setTitleTextAttributes(segmentTextAttributes, for: .normal)
        loginTypeSegmentedControl.setTitleTextAttributes(selectedSegmentTextAttributes, for: .selected)
    }
    
}
