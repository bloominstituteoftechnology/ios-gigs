//
//  LoginViewController.swift
//  Gigs
//
//  Created by Gerardo Hernandez on 1/21/20.
//  Copyright © 2020 Gerardo Hernandez. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var SignOnLoginSegmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signOnLoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - IBActions
    @IBAction func loginSegementedState(_ sender: UISegmentedControl) {
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
