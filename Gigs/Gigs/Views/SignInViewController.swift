//
//  SignInViewController.swift
//  Gigs
//
//  Created by Joel Groomer on 9/10/19.
//  Copyright © 2019 julltron. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    // MARK: - Outloets
    @IBOutlet weak var segSignUpIn: UISegmentedControl!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnSignUpIn: UIButton!
    
    // MARK: Public Variables
    
    
    // MARK: Private Variables
    
    
    // MARK: - View Functions
    
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

    // MARK: - Actions
    @IBAction func signUpInChanged(_ sender: Any) {
    }
    
    @IBAction func signUpInButtonTapped(_ sender: Any) {
    }
}
