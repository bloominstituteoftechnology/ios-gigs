//
//  LoginViewController.swift
//  Gigs
//
//  Created by Joshua Rutkowski on 1/21/20.
//  Copyright © 2020 Josh Rutkowski. All rights reserved.
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

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - IBActions
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func signInTypeChanged(_ sender: UISegmentedControl) {
    }
    
}
