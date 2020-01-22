//
//  LoginViewController.swift
//  iOs-Gigs
//
//  Created by Sal Amer on 1/21/20.
//  Copyright © 2020 Sal Amer. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    //IB Outlets
    
    @IBOutlet weak var signInSegmentSwitch: UISegmentedControl!
    @IBOutlet weak var usernameTxtFld: UITextField!
    @IBOutlet weak var passwordTxtFld: UITextField!
    @IBOutlet weak var signinBtn: UIButton!
    
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
    
    //IB Actions
    @IBAction func signInSegmentSwitched(_ sender: Any) {
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
    }
    
}
