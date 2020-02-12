//
//  LoginViewController.swift
//  Gigs
//
//  Created by Enrique Gongora on 2/12/20.
//  Copyright © 2020 Enrique Gongora. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var signInButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func signInTypeChanged(_ sender: UISegmentedControl) {
    }
    
    
    @IBAction func buttonTapped(_ sender: UIButton) {
    }
    
}
