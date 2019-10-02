//
//  LoginViewController.swift
//  Gigs
//
//  Created by Jesse Ruiz on 10/2/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var signInSignUpSegment: UISegmentedControl!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signUpLoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Actions
    @IBAction func segmentChange(_ sender: UISegmentedControl) {
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
    }
    

}

