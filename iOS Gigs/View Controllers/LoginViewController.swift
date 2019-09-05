//
//  LoginViewController.swift
//  iOS Gigs
//
//  Created by Andrew Ruiz on 9/4/19.
//  Copyright © 2019 Andrew Ruiz. All rights reserved.
//

import UIKit

enum LoginType {
    case signup
    case signin
}

class LoginViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signUpLogin: UIButton!
    
    var gigController: GigController!
    var loginType : LoginType = .signup
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func segmentedControlButtonTapped(_ sender: Any) {
        
        // 0 is "Sign up". 1 is "Sign In"
        if segmentedControl.selectedSegmentIndex == 0 {
            loginType = .signup
            signUpLogin.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .signin
            signUpLogin.setTitle("Sign In", for: .normal)
        }
    }
    
    @IBAction func signUpLoginButtonTapped(_ sender: Any) {
        
        if loginType == .signup {
            let alert = UIAlertController(title: "Sign Up Successful", message: "Now please sign in", preferredStyle: .alert)
        } else if loginType == .signin {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
            
        }
    }
    
    
}
