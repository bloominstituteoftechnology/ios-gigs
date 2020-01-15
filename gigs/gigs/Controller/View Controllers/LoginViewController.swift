//
//  LoginViewController.swift
//  gigs
//
//  Created by Kenny on 1/15/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    //MARK: IBOutlets
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    //MARK: IBActions
    @IBAction func loginMethodWasChanged(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            loginType = .signUp
        case 1:
            loginType = .signIn
        default: fatalError("Only 2 segmented controls exist! Control #\(segmentedControl.selectedSegmentIndex) is out of range!")
        }
    }
    
    @IBAction func loginButtonWasTapped(_ sender: Any) {
        guard let usernameText = usernameTextField.text,
            usernameText != "",
            let passwordText = passwordTextField.text,
            passwordText != ""
        else {return}
        let user = User(username: usernameText, password: passwordText)
        if loginType == .signUp {
            gigController.signUp(with: user) { (error) in
                
            }
        } else {
            gigController.signIn(with: user) { (error) in
                
            }
        }
    }
    
    
    var gigController: GigController!
    var loginType: LoginType = .signUp //control defaults to 0 and change won't be called until the control is tapped, so default to the first control's value
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    

}
