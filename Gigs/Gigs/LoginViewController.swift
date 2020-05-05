//
//  LoginViewController.swift
//  Gigs
//
//  Created by Nonye on 5/5/20.
//  Copyright © 2020 Nonye Ezekwo. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    //MARK: - OUTLETS
    
    @IBOutlet weak var signUpInSegment: UISegmentedControl!
    @IBOutlet weak var usernameText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    @IBOutlet weak var signUpInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUpInSegmentTapped(_ sender: Any) {
    }
    @IBAction func signUpInTapped(_ sender: Any) {
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
