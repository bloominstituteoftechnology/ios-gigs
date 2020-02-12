//
//  LoginViewController.swift
//  gigs
//
//  Created by Keri Levesque on 2/12/20.
//  Copyright © 2020 Keri Levesque. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    //MARK: Outlets
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var button: UIButton!
    
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
 //MARK: Actions
    
    @IBAction func signInsignUp(_ sender: UISegmentedControl) {
    }
    
    
    @IBAction func signInsignUpButton(_ sender: UIButton) {
    }
}
