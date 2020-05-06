//
//  LoginViewController.swift
//  Gigs
//
//  Created by Vincent Hoang on 5/5/20.
//  Copyright © 2020 Vincent Hoang. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            signupButton.setTitle("Sign Up", for: .normal)
        } else if sender.selectedSegmentIndex == 1 {
            signupButton.setTitle("Sign In", for: .normal)
        }
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        if !checkPasswordNotEmpty() {
            if !checkPasswordNotEmpty(){
                let buttonMode = segmentedControl.selectedSegmentIndex
                
                if buttonMode == 0 {
                    
                } else {
                    
                }
            }
        }
    }
    
    private func checkUsernameNotEmpty() -> Bool {
        let username = usernameTextField.text ?? ""
        
        if username.isEmpty {
            generateAlert(message: "Username field must not be empty!")
            
            return false
        }
        
        return true
    }
    
    private func checkPasswordNotEmpty() -> Bool {
        let password = passwordTextField.text ?? ""
        
        if password.isEmpty {
            generateAlert(message: "Password field must not be empty!")
            
            return false
        }
        
        return true
    }
    
    private func checkPasswordRegex() {
        
    }
    
    private func generateAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
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
