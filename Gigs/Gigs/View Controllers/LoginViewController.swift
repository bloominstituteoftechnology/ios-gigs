//
//  LoginViewController.swift
//  Gigs
//
//  Created by Angel Buenrostro on 8/24/19.
//  Copyright © 2019 Angel Buenrostro. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case signIn
}

class LoginViewController: UIViewController {
    
    // Properties
    
    @IBOutlet private weak var loginTypeSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var signInButton: UIButton!
    
    var loginType = LoginType.signIn
    
    var bgColor = #colorLiteral(red: 0.2192418128, green: 0.5473350286, blue: 0.9997488856, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupViews()
    }
    
    func setupViews(){
        loginTypeSegmentedControl.backgroundColor = bgColor
        signInButton.backgroundColor = bgColor
        signInButton.tintColor = .white
        
        loginTypeSegmentedControl.layer.cornerRadius = 6.0
        signInButton.layer.cornerRadius = 6.0
    }
    
    // Action Handlers
    
    @IBAction func signInTypeChanged(_ sender: UISegmentedControl) {
        // switch UI between modes
        if sender.selectedSegmentIndex == 0 {
            loginType = .signIn
            signInButton.setTitle("Sign In", for: .normal)
        } else {
            loginType = .signUp
            signInButton.setTitle("Sign Up", for: .normal)
        }
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
