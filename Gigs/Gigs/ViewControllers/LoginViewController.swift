//
//  LoginViewController.swift
//  Gigs
//
//  Created by Joseph Rogers on 11/4/19.
//  Copyright © 2019 Joseph Rogers. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    //MARK: Properties
    
    @IBOutlet private weak var usernameTextField: UITextField!
       @IBOutlet private weak var passwordTextField: UITextField!
       @IBOutlet private weak var loginTypeSegmentedControl: UISegmentedControl!
       @IBOutlet private weak var signInButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
    }
    
    
    @IBAction func signInTypeChanged(_ sender: UISegmentedControl) {
        
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
