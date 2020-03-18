//
//  LoginViewController.swift
//  Gigs
//
//  Created by Breena Greek on 3/17/20.
//  Copyright © 2020 Breena Greek. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case signIn
}

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
    var gigController: GigController?
    var loginType = LoginType.signUp
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton.backgroundColor = UIColor(hue: 190/360, saturation: 70/100, brightness: 80/100, alpha: 1.0)
        saveButton.tintColor = .white
        saveButton.layer.cornerRadius = 8.0
    }
    
    // MARK: - IBOutlets

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    //MARK: - IBActions
    
    @IBAction func segmentedControlToggle(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            loginType = .signUp
            saveButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .signIn
            saveButton.setTitle("Sign In", for: .normal)
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let gigController = gigController else { return }
        
        guard let username = usernameTextField.text,
            username.isEmpty == false,
            let password = passwordTextField.text,
            username.isEmpty == false else {
                return
        }
        
        let user = User(username: username, password: password)
        
        switch loginType {
        case .signUp:
            gigController.signUp(with: user) { (error) in
                guard error == nil else {
                    print("Error signing up: \(error)")
                    return
                }
                
                DispatchQueue.main.async {
                    let alerController = UIAlertController(title: "SignUp Successful", message: "Now, please LogIn", preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alerController.addAction(alertAction)
                    
                    self.present(alerController, animated: true) {
                        self.loginType = .signIn
                        self.segmentedControl.selectedSegmentIndex = 1
                        self.saveButton.setTitle("Sign In", for: .normal)
                    }
                }
            }
        case .signIn:
            gigController.signIn(with: user) { (error) in
                guard error == nil else {
                    print("Error logging in: \(error)")
                    return
                }
                
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
}
