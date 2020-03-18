//
//  LoginViewController.swift
//  Gigs
//
//  Created by Lambda_School_Loaner_241 on 3/17/20.
//  Copyright © 2020 Lambda_School_Loaner_241. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // Mark:- IBOutlets/Properties
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginSegControl: UISegmentedControl!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginSegControlToggle(_ sender: Any) {
    }
    
  

}
