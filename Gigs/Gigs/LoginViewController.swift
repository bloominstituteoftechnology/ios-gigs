//
//  LoginViewController.swift
//  Gigs
//
//  Created by Jon Bash on 2019-10-30.
//  Copyright © 2019 Jon Bash. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var signInTypeControl: UISegmentedControl!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
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

    @IBAction func signInTypeChanged(_ sender: UISegmentedControl) {
    }
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
    }
    
}
