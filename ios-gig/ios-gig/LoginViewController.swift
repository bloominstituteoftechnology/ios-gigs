//
//  LoginViewController.swift
//  ios-gig
//
//  Created by Lambda_School_Loaner_268 on 2/12/20.
//  Copyright © 2020 Lambda. All rights reserved.
//

import UIKit

enum LoginType: String {
    case logIn = "logIn"
    case signUp = "signUp"
}

class LoginViewController: UIViewController {
    
 
    
    // MARK: - Properties
       
    var gigController: GigController?
       
    var loginType: LoginType = .signUp

    // MARK: - Outlets
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var logInSignUp: UISegmentedControl!
    
    @IBOutlet weak var logInSignInButton: UIButton!
    
    
  override func viewDidLoad() {
       super.viewDidLoad()
   }

    // MARK: - Actions
    
    @IBAction func pathChanged(_ sender: Any) {
        if logInSignUp.selectedSegmentIndex == 0 {
            loginType = .logIn
            logInSignInButton.titleLabel!.text = "Log In"
        }
        if logInSignUp.selectedSegmentIndex == 1 {
            loginType = .signUp
            logInSignInButton.titleLabel!.text = "Sign Up!"
        }
    }
    
    // This function is called when the user taps the UI Button on the view
    @IBAction func logInSignInButtonClicked(_ sender: Any) {
        //Check to see if the GigController exists
        guard let gigController = gigController else { return }
        
        // Checks to make sure that the required fields are filled in
        if let username = usernameTextField.text, !username.isEmpty,
            let password = passwordTextField.text, !password.isEmpty {
                let user = User(username: username, password: password)
                
                // If one is trying to log in:
                if loginType == .logIn {
                    gigController.logIn(with: user) { (error) in
                        if let error = error {
                            NSLog("Error occured during log in: \(error)")
                        } else {
                            DispatchQueue.main.async {
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                    }
                } else {
                    // If one is trying to sign up
                    gigController.signUp(with: user) { (error) in
                        if let error = error {
                            NSLog("Error occured during sign up: \(error)")
                        } else {
                            DispatchQueue.main.async {
                            let alertController = UIAlertController(title: "Sign Up Successful", message: "Now please log in.", preferredStyle: .alert)
                            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alertController.addAction(alertAction)
                            self.present(alertController, animated: true) {
                                self.loginType = .logIn
                                self.logInSignUp.selectedSegmentIndex = 0
                                self.logInSignInButton.setTitle("Log in", for: .normal)
                        }
                    }
            }
    }
}

    
   
    
    
    


}
}
}
