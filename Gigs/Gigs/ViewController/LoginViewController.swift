//
//  LoginViewController.swift
//  Gigs
//
//  Created by Nichole Davidson on 3/11/20.
//  Copyright © 2020 Nichole Davidson. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case login
}
class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginSegmentedControl: UISegmentedControl!
    @IBOutlet weak var signInButton: UIButton!
    
    var gigController: GigController?
    var loginType = LoginType.signUp
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signInTypeChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            loginType = .signUp
            signInButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .login
        }
    }

    @IBAction func signInTapped(_ sender: UIButton) {
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
