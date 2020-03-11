//
//  LoginViewController.swift
//  Gigs
//
//  Created by Mark Gerrior on 3/11/20.
//  Copyright © 2020 Mark Gerrior. All rights reserved.
//

import UIKit

enum LoginType: Int {
    case signUp = 0
    case logIn
}

class LoginViewController: UIViewController {

    // MARK: - Properites

    var loginType = LoginType.signUp {
        didSet {
            switch loginType {
            case .signUp:
                credentialsMode.selectedSegmentIndex = 0
                credentialsButtonLabel.setTitle("Sign Up", for: .normal)
            case .logIn:
                credentialsMode.selectedSegmentIndex = 1
                credentialsButtonLabel.setTitle("Log In", for: .normal)
            }
        }
    }

    // MARK: - Outlets
    
    @IBOutlet weak var credentialsMode: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var credentialsButtonLabel: UIButton!
    
    // MARK: - Actions
    
    /// User has pressed the segmented control to choose between Sign Up and Log In
    @IBAction func selectModeButton(_ sender: Any) {
        // I prefer to check selectedSegmentIndex vs. loginType because
        // I don't trust that I can know the state of the control 100% of the time
        if let newState = LoginType(rawValue: credentialsMode.selectedSegmentIndex) {
            loginType = newState
        }
    }
    
    /// User has pressed the action button to either Sign Up or Log In
    @IBAction func credentialsButton(_ sender: Any) {
    }
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}
