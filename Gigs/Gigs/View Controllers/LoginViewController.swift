//
//  LoginViewController.swift
//  Gigs
//
//  Created by Lambda_School_Loaner_259 on 3/11/20.
//  Copyright © 2020 DeVitoC. All rights reserved.
//

import UIKit

enum LoginType {
    case logIn
    case signUp
}

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    var gigController: GigController?
    var loginType = LoginType.signUp
    
    // MARK: - IBOutlets
    @IBOutlet var loginTypeSegementedControl: UISegmentedControl!
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var saveButton: UIButton!
    
    
    // MARK: - IBActions
    @IBAction func loginTypeSegmentedControlChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            loginType = .signUp
            saveButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .logIn
            saveButton.setTitle("Log In", for: .normal)
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        
        if let username = usernameTextField.text,
            !username.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty {
            let user = User(username: username, password: password)
            
            if loginType == .signUp {
                gigController?.signUp(with: user, completion: { error in
                    if let error = error {
                        NSLog("Error occured during sign up: \(error)")
                    } else {
                        DispatchQueue.main.async {
                            let alertController = UIAlertController(title: "Sign up successful!", message: "Now please log in.", preferredStyle: .alert)
                            let okbutton = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alertController.addAction(okbutton)
                            self.present(alertController, animated: true) {
                                self.loginType = .logIn
                                self.loginTypeSegementedControl.selectedSegmentIndex = 1
                                self.saveButton.setTitle("Log In", for: .normal)
                            }
                        }
                    }
                })
            } else {
                gigController?.signIn(with: user, completion: { error in
                    if let error = error {
                        NSLog("Error occuring during log in: \(error)")
                        
                    } else {
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                })
            }
        }
    }
    
    

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
