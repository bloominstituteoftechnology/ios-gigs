//
//  LoginViewController.swift
//  gigs
//
//  Created by Keri Levesque on 2/12/20.
//  Copyright © 2020 Keri Levesque. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case signIn
}

class LoginViewController: UIViewController {
    //MARK: Outlets
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameTextfield: UITextField! // thats supposed to be cap F (typo)
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var button: UIButton!
    
    //MARK: Properties
    var gigController: GigController?
    var loginType = LoginType.signUp
   
    //MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
 //MARK: Actions
    
    @IBAction func signInsignUp(_ sender: UISegmentedControl) {
        // switch UI between login types
              if sender.selectedSegmentIndex == 0 {
                  // sign up mode
                  loginType = .signUp
                  button.setTitle("Sign Up", for: .normal)
              } else {
                  // sign in mode
                  loginType = .signIn
                  button.setTitle("Sign In", for: .normal)
              }
          }

    @IBAction func buttonTapped(_ sender: UIButton) {
        guard let gigController = gigController else { return }
               
               if let username = usernameTextfield.text,
                   !username.isEmpty,
                   let password = passwordTextField.text,
                   !password.isEmpty {
                   let user = User(username: username, password: password)
                   
                   if loginType == .signUp{
                       gigController.signUp(with: user) { (error) in
                           if let error = error {
                               NSLog("Error occurred during sign up: \(error)")
                           } else {
                               DispatchQueue.main.async {
                                   self.signUpAlert()
                               }
                           }
                       }
                   }else {
                       gigController.signIn(with: user) { (error) in
                           if let error = error {
                               NSLog("Error logging in: \(error)")
                           } else {
                               DispatchQueue.main.async {
                                   self.dismiss(animated: true, completion: nil)
                               }
                           }
                       }
                   }
               }
    }
        //MARK: Methods
        
        func signUpAlert() {
            let signUpAlert = UIAlertController(title: "Sign Up Successful", message: "Please log in.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ok", style: .default
                , handler: nil)
            signUpAlert.addAction(alertAction)
            self.present(signUpAlert, animated: true) {
                self.loginType = .signUp
                self.segmentedControl.selectedSegmentIndex = 1
                self.button.setTitle("Sign In", for: .normal)
            }
        }
}
