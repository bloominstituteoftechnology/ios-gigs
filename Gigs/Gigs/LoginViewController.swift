//
//  LoginViewController.swift
//  Gigs
//
//  Created by Shawn Gee on 3/11/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    enum LoginType: Int {
        case signup, login
    }

    //MARK: - IBOutlets
    
    @IBOutlet weak var loginTypeSelector: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signupLoginButton: UIButton!
    
    
    //MARK: - IBActions
    
    @IBAction func loginTypeSelected(_ sender: UISegmentedControl) {
        loginType = LoginType(rawValue: sender.selectedSegmentIndex) ?? .signup
        signupLoginButton.titleLabel?.text = loginType == .signup ? "Sign Up" : "Log In"
    }
    
    @IBAction func signupLoginButtonTapped(_ sender: UIButton) {
        // sign up or log in
        /* In the button's action, based on the loginType property, perform the corresponding method in the gigController to either sign them up or log them in. If the sign up is successful, present an alert telling them they can log in. If the log in is successful, dismiss the view controller to take them back to the GigsTableViewController. */
    }
    
    //MARK: - Properties
    
    var gigController: GigController?
    
    
    //MARK: - Private
    
    private var loginType: LoginType = .signup
    
    //MARK: - View Lifecycle
    
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
