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

        // Do any additional setup after loading the view.
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
        guard let username = usernameTextField.text,
            let password = passwordTextField.text,
        
            //  are the textfields empty ?
            !username.isEmpty,
            !password.isEmpty else { return }
        
        let user = User(username: username, password: password)
        
        //  use enum to access function
        if selectLoginType == .signUp {
            
        }
        
    }
    

}
