//
//  LoginViewController.swift
//  Gigs
//
//  Created by Sameera Roussi on 5/9/19.
//  Copyright © 2019 Sameera Roussi. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: -Properties

    // MARK: Outlets
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    
    // MARK: - View states
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Customize the sign in button
        signInButton.backgroundColor = UIColor(hue: 301/368, saturation: 78/100, brightness: 58/100, alpha: 1.0)
    }
    
    
    
    @IBAction func segmentControlTapped(_ sender: Any) {
    }
    @IBAction func signInButtonTapped(_ sender: Any) {
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
