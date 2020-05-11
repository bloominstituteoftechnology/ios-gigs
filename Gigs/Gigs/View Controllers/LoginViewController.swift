//
//  LoginViewController.swift
//  Gigs
//
//  Created by Bronson Mullens on 5/11/20.
//  Copyright © 2020 Bronson Mullens. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var signUpSignInControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpSignInButton: UIButton!
    
    // MARK: - IBActions
    @IBAction func signSegmentedTapped(_ sender: Any) {
    }
    
    @IBAction func signButtonTapped(_ sender: Any) {
    }
    
    // MARK: - Properties
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
