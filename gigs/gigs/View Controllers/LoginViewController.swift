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
        
        // collect user content (username, password)
        if let username = usernameTextfield.text,
            !username.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty {
            let user = User(username: username, password: password)
            
            // determine which mode to use
            if loginType == .signUp {
                // perform signUp API call
                gigController.signUp(with: user) { (error) in
                    if let error = error {
                        NSLog("Error occurred during sign up: \(error)")
                    } else {
                        DispatchQueue.main.async {
                            let alertController = UIAlertController(title: "Sign Up Successful", message: "Now please log in.", preferredStyle: .alert)
                            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alertController.addAction(alertAction)
                            self.present(alertController, animated: true) {
                                self.loginType = .signIn
                                self.segmentedControl.selectedSegmentIndex = 1
                                self.button.setTitle("Sign In", for: .normal)
                            }
                        }
                    }
                }
            } else {
                // perform signIn API call
                gigController.signIn(with: user) { (error) in
                    if let error = error {
                        NSLog("Error occurred during sign up: \(error)")
                    } else {
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }


}
