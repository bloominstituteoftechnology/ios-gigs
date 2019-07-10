//
//  LoginViewController.swift
//  iOS-Gigs
//
//  Created by Kat Milton on 7/10/19.
//  Copyright © 2019 Kat Milton. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet var signInTypeSegmentedControl: UISegmentedControl!
    @IBOutlet var signInButton: UIButton!
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func buttonPressed(_ sender: UIButton) {
    
    }
    
    @IBAction func signInSegmentChanged(_ sender: UISegmentedControl) {
        
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
