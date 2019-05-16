//
//  LoginViewController.swift
//  Gigs
//
//  Created by Thomas Cacciatore on 5/16/19.
//  Copyright © 2019 Thomas Cacciatore. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    
    
    @IBAction func segmentedControlsChanged(_ sender: Any) {
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
    }
    
    
    
    
    
   
    @IBOutlet weak var loginSegmentedControls: UISegmentedControl!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    

}
