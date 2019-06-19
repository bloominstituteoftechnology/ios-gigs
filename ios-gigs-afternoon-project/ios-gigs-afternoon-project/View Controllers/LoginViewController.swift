//
//  LoginViewController.swift
//  ios-gigs-afternoon-project
//
//  Created by Alex Shillingford on 6/19/19.
//  Copyright © 2019 Alex Shillingford. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var signInButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signInTypeChanged(_ sender: UISegmentedControl) {
        
    }
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        
    }
}
