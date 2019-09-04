//
//  LoginViewController.swift
//  Gigs
//
//  Created by Ciara Beitel on 9/4/19.
//  Copyright © 2019 Ciara Beitel. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var signUpOrInSegCon: UISegmentedControl!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpOrInButton: UIButton!
    
    @IBAction func signUpOrInSegCon(_ sender: Any) {
    }
    
    @IBAction func signUpOrInButton(_ sender: Any) {
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
