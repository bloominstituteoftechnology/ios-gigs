//
//  LoginViewController.swift
//  Gigs
//
//  Created by Sameera Roussi on 5/9/19.
//  Copyright © 2019 Sameera Roussi. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    
    // MARK: -Properties

    enum LoginType {
        case signUp
        case signIn
    }
    
    // Keep track of the login type selected by the segmented controller
     var loginType = LoginType.signUp
    
    // MARK: - View states
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Customize the sign in button
        signInButton.backgroundColor = UIColor(hue: 301/368, saturation: 78/100, brightness: 58/100, alpha: 1.0)
        signInButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        signInButton.tintColor = .white
        signInButton.layer.cornerRadius = 8.0
        signInButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    }
    
    
    
    @IBAction func segmentControlTapped(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            loginType = .signUp
            signInButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .signIn
            signInButton.setTitle("Sign In", for: .normal)
        }
        
    }
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {

        
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
