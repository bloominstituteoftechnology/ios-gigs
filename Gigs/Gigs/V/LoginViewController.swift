//
//  LoginViewController.swift
//  Gigs
//
//  Created by Nathan Hedgeman on 8/7/19.
//  Copyright © 2019 Nate Hedgeman. All rights reserved.
//

import UIKit

enum LoginType {
    case signIn
    case signUp
}

class LoginViewController: UIViewController {
    
    //Properties
    var gigController: GigController!
    
    var loginType = LoginType.signUp
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signButton: UIButton!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        signButton.setTitle("Sign Up", for: .normal)
    }
    
    
    @IBAction func segmentedControllAction(_ sender: Any) {
        
        if segmentedControl.selectedSegmentIndex == 0 {
            
            loginType = .signUp
            signButton.setTitle("Sign Up", for: .normal)
        
        } else {
            
            loginType = .signIn
            signButton.setTitle("Sign In", for: .normal)
            
        }
    }
    
    @IBAction func signButtonTapped(_ sender: Any) {
        
        guard let gigController = gigController else { return }
        
        if let username = self.usernameTextField.text, !username.isEmpty,
            let password = self.passwordTextField.text, !password.isEmpty {
            
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
                            
                            self.present(alertController, animated: true, completion: {
                                
                                self.loginType = .signIn
                                self.segmentedControl.selectedSegmentIndex = 1
                                self.signButton.setTitle("Sign In", for: .normal)
                                
                            })
                        }
                    }
                }
            } else {
                
                gigController.signIn(with: user) { (error) in
                    if let error = error {
                        NSLog("Error occurred during sign in: \(error)")
                    } else {
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
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
