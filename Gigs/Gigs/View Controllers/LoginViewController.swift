//
//  LoginViewController.swift
//  Gigs
//
//  Created by Karen Rodriguez on 3/11/20.
//  Copyright © 2020 Hector Ledesma. All rights reserved.
//

// MARK: -


// MARK: - Nice here we go


import UIKit

enum LoginType {
    case signUp
    case logIn
}

class LoginViewController: UIViewController {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var userSubmitButton: UIButton!
    
    var gigController: GigController?
    var loginType: LoginType = .signUp
    
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

    @IBAction func segmentChange(_ sender: Any) {
        if segmentControl.selectedSegmentIndex == 0 {
            self.loginType = .signUp
            userSubmitButton.setTitle("Sign Up", for: .normal)
        } else {
            self.loginType = .logIn
            userSubmitButton.setTitle("Log In", for: .normal)
        }
    }
    @IBAction func userSubmitTapped(_ sender: Any) {
        if let username = usernameField.text,
            !username.isEmpty,
            let password = passwordField.text,
            !password.isEmpty  {
            let user = User(username: username, password: password)
            
            if self.loginType == .signUp {
                gigController?.signUp(with: user, completion: { error in
                    if let error = error {
                        NSLog("Error when pressing sign up button: \(error)")
                        return
                    } else {
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Sign Up Successful", message: "You can now Log In", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alert.addAction(okAction)
                            
                            self.present(alert, animated: true) {
                                self.loginType = .logIn
                                self.segmentControl.selectedSegmentIndex = 1
                                self.userSubmitButton.setTitle("Log In", for: .normal)
                            }
                        }
                    }
                })
            } else {
                gigController?.logIn(with: user, completion: { error in
                    if let error = error {
                        NSLog("Error occurred during log in: \(error)")
                    } else {
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                })
            }
        }
        
    }
    
}
