//
//  LoginViewController.swift
//  Gigs
//
//  Created by Kenneth Jones on 5/10/20.
//  Copyright © 2020 Kenneth Jones. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var signUpLogInControl: UISegmentedControl!
    @IBOutlet weak var signUpLogInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUpLogInChanged(_ sender: Any) {
    }
    
    @IBAction func signUpLogInTapped(_ sender: Any) {
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
