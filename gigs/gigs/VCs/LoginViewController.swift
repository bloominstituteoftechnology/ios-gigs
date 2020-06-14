//
//  LoginViewController.swift
//  gigs
//
//  Created by ronald huston jr on 5/5/20.
//  Copyright © 2020 HenryQuante. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var gigController: GigController?
    
    enum LoginType {
        case signIn
        case signUp
    }
    
    var selectLoginType: LoginType = .signIn {
        didSet {
            switch selectLoginType {
            case .signIn:
                signUpButton.setTitle("log in", for: .normal)
            case .signUp:
                signUpButton.setTitle("sign up", for: .normal)
            }
        }
    }
    
    //  MARK: - UI connections
    @IBOutlet weak var signUpSegment: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        usernameTextField.becomeFirstResponder()
    }
    
    //  MARK: - IBAction
    @IBAction func segmentedControlAction(_ sender: Any) {
        
        switch signUpSegment.selectedSegmentIndex {
        case 0:
            selectLoginType = .signUp
            passwordTextField.textContentType = .password
        case 1:
            selectLoginType = .signIn
            passwordTextField.textContentType = .newPassword
        default: fatalError()
        }
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        //  create user from textfield
        if let username = usernameTextField.text,
            !username.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty {
            let user = User(username: username, password: password)
            
            if selectLoginType == .signUp {
                gigController?.signUp(with: user, completion: { result in
                    do {
                        let success = try result.get()
                        if success {
                            DispatchQueue.main.async {
                                let alertController = UIAlertController(title: "sign up siccessful", message: "please log in", preferredStyle: .alert)
                                let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                alertController.addAction(alertAction)
                                self.present(alertController, animated: true) {
                                    self.selectLoginType = .signIn
                                    self.signUpSegment.selectedSegmentIndex = 1
                                    self.signUpButton.setTitle("sign in", for: .normal)
                                }
                            }
                        }
                    } catch {
                        print("error signing up: \(error)")
                    }
                })
            }
        }
    }
    @IBAction func signInTypeChanged(_ sender: UISegmentedControl) {
        //  switch UI between login types
        if sender.selectedSegmentIndex == 0 {
            //  sign up
            selectLoginType = .signUp
            signUpButton.setTitle("sign up", for: .normal)
        } else {
            //  sign in
            selectLoginType = .signIn
            signUpButton.setTitle("sign in", for: .normal)
        }
    }
}
