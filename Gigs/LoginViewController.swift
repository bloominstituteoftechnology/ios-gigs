//
//  LoginViewController.swift
//  Gigs
//
//  Created by Lambda_School_Loaner_201 on 11/5/19.
//  Copyright © 2019 Christian Lorenzo. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var segmentedLoginSignUp: UISegmentedControl!
    
    @IBOutlet weak var usernameOutlet: UITextField!
    
    @IBOutlet weak var passwordOutlet: UITextField!
    
    @IBOutlet weak var signUpSignInOutlet: UIButton!
    
    
    @IBAction func segmentedLoginSignupAction(_ sender: UISegmentedControl) {
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
