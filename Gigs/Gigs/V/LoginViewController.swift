//
//  LoginViewController.swift
//  Gigs
//
//  Created by Nathan Hedgeman on 8/7/19.
//  Copyright © 2019 Nate Hedgeman. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    //Properties
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signButton: UIButton!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func segmentedControllAction(_ sender: Any) {
        
    }
    
    @IBAction func signButtonTapped(_ sender: Any) {
        
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
