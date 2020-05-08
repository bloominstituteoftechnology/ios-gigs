//
//  LoginViewController.swift
//  GigsApp
//
//  Created by Clayton Watkins on 5/8/20.
//  Copyright © 2020 Clayton Watkins. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var segmentedController: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    
    //MARK: - IBActions
    @IBAction func segemetedControllerChanged(_ sender: Any) {
        if segmentedController.selectedSegmentIndex == 0{
            loginButton.setTitle("Sign Up", for: .normal)
        } else {
            loginButton.setTitle("Sign In", for: .normal)
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
    }
    
}
