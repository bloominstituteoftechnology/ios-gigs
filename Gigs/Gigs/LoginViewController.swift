//
//  LoginViewController.swift
//  Gigs
//
//  Created by Stephanie Ballard on 2/12/20.
//  Copyright © 2020 Stephanie Ballard. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case signIn
}

class LoginViewController: UIViewController {

    var gigController: GigController?
    var loginType = LoginType.signUp
    
    @IBOutlet weak var signUpAndLogInSegmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInAndSignUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logInAndSignUpButton.backgroundColor = UIColor(hue: 190/360, saturation: 70/100, brightness: 80/100, alpha: 1.0)
        logInAndSignUpButton.tintColor = .white
        logInAndSignUpButton.layer.cornerRadius = 8.0
        // Do any additional setup after loading the view.
    }
    
    @IBAction func logInAndSignUpButtonTapped(_ sender: UIButton) {
        // perform login or sign up operation based on loginType
            
            //unwrap the apiController
            guard let gigController = gigController else { return }
            
            //collect user content (usernmae, password)
            if let username = usernameTextField.text,
                !username.isEmpty,
                let password = passwordTextField.text,
                !password.isEmpty {
                let user = User(username: username, password: password)
                //determine which mode to use
                if loginType == .signUp {
                    //perform sign up API call
                    gigController.signUp(with: user) { (error) in
                        if let error = error {
                            NSLog("Error occured during sign up: \(error)")
                        } else {
                            DispatchQueue.main.async {
                                let alertController = UIAlertController(title: "Sign up Successful", message: "Now please log in.", preferredStyle: .alert)
                                let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                                alertController.addAction(alertAction)
                                self.present(alertController, animated: true) {
                                    self.loginType = .signIn
                                    self.signUpAndLogInSegmentedControl.selectedSegmentIndex = 1
                                    self.logInAndSignUpButton.setTitle("Sign In", for: .normal)
                                }
                            }
                        }
                    }
                    
                } else {
                    //perform signin API call
                    gigController.signIn(with: user) { (error) in
                        if let error = error {
                            NSLog("Error occured during sign up: \(error)")
                        } else {
                            DispatchQueue.main.async {
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                    }
                }
            
            }
            //perform correct API call
        
    }
    
    @IBAction func signUpAndLoginSegmentedValueChanged(_ sender: UISegmentedControl) {
        // switch UI between login types
        if sender.selectedSegmentIndex == 0 {
            // sign up mode
            loginType = .signUp
            logInAndSignUpButton.setTitle("Sign Up", for: .normal)
        } else {
            //sign in mode
            loginType = .signIn
            logInAndSignUpButton.setTitle("Sign In", for: .normal)
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
