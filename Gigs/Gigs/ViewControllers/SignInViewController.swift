//
//  SignInViewController.swift
//  Gigs
//
//  Created by Cora Jacobson on 7/11/20.
//  Copyright © 2020 Cora Jacobson. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var signInSegmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signInButton.layer.cornerRadius = 8
    }
    @IBAction func signInTypeSegmentedControl(_ sender: UISegmentedControl) {
    }
    
    @IBAction func signInButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
