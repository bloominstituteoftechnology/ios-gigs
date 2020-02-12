//
//  LoginViewController.swift
//  Gigs
//
//  Created by Elizabeth Wingate on 2/12/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case signIn
}

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
     @IBOutlet weak var passwordTextField: UITextField!
     @IBOutlet weak var loginTypeSegmentedControl: UISegmentedControl!
     @IBOutlet weak var signInButton: UIButton!
    
     var gigController: GigController!
     var loginType = LoginType.signUp
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
     @IBAction func signInButtonTapped(_ sender: UIButton) {
        guard let gigController = gigController else { return }
            
      if let username = usernameTextField.text,
            !username.isEmpty,
             let password = passwordTextField.text,
            !password.isEmpty {
            let user = User(username: username, password: password)
         
            if loginType == .signUp {
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
                self.loginTypeSegmentedControl.selectedSegmentIndex = 1
                self.signInButton.setTitle("Sign In", for: .normal)
             }
          }
       }
    }
        } else {
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
    
    @IBAction func signInTypeChanged(_ sender: UISegmentedControl) {
          if sender.selectedSegmentIndex == 0 {
              signInButton.setTitle("Sign Up", for: .normal)
          } else {
              loginType = .signIn
              signInButton.setTitle("Sign In", for: .normal)
          }
    }
}
