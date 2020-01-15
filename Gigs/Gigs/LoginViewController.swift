//
//  LoginViewController.swift
//  Gigs
//
//  Created by Jorge Alvarez on 1/15/20.
//  Copyright © 2020 Jorge Alvarez. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var segmentLabel: UISegmentedControl!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    
    @IBAction func segmentTapped(_ sender: UISegmentedControl) {
    }
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
    }
    
    
    
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

}
