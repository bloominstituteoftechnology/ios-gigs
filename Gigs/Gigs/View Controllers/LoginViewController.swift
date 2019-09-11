//
//  LoginViewController.swift
//  Gigs
//
//  Created by Jessie Ann Griffin on 9/10/19.
//  Copyright © 2019 Jessie Griffin. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // customize button appearance (background, tint, and corner radius)
        logInButton.backgroundColor = UIColor(hue: 190/360, saturation: 70/100, brightness: 80/100, alpha: 1)
        logInButton.tintColor = .white
        logInButton.layer.cornerRadius = 8.0
        
    }
    
    @IBAction func segmentedControlTypeChanged(_ sender: Any) {
    }
    
    @IBAction func logInButtonTapped(_ sender: Any) {
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
