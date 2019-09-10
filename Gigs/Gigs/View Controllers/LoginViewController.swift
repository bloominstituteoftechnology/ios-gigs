//
//  LoginViewController.swift
//  Gigs
//
//  Created by John Kouris on 9/9/19.
//  Copyright © 2019 John Kouris. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var signInButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
    }
    
    @IBAction func signInTypeChanged(_ sender: UISegmentedControl) {
    }
    
    

}
