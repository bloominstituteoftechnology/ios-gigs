//
//  LoginViewController.swift
//  Gigs
//
//  Created by macbook on 10/2/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var logInSegmentedControl: UISegmentedControl!
    @IBOutlet weak var logInButton: UIButton!
    
    //MARK: - Properties
    var gigController: GigController!
    //TODO: - will be used to receive the GigsTableViewController's GigController through the prepare(for segue.
    
    //var loginType: LoginType?
    var loginType = LoginType.signUp
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    // MARK: - Actions Handlers
    
    // LogIn/SignUp Segment Controller
    @IBAction func logInSegmentedControlChanged(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            loginType = .signUp
            logInButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .logIn
            logInButton.setTitle("Log In", for: .normal)
        }
    }
    
    // LogIn/SignUp Button
    @IBAction func logInButtonTapped(_ sender: UIButton) {
        
        // Create a user
        guard let username = usernameTextField.text,
            let password = passwordTextField.text,
            username != "",
            !password.isEmpty else { return }
        
        let user = User(username: username, password: password)
        
        // perform login or sign up operation based on loginType
        if loginType == .signUp {
            signUp(with: user)
            
        } else {
            logIn(with: user)
            
        }
        
    }
    
    func signUp(with user: User) {
        
        gigController?.signUp(with: user, completion: { (error) in
            if let error = error {
                
                NSLog("Error occurred during sign up: \(error)")
                
            } else {
                let alert = UIAlertController(title: "Sign Up Successful",
                                              message: "Now please log in",
                                              preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                alert.addAction(okAction)
                
                DispatchQueue.main.async {
                    self.present(alert, animated: true) {
                        self.loginType = .logIn
                        self.logInSegmentedControl.selectedSegmentIndex = 1
                        self.logInButton.setTitle("Log In", for: .normal)
                    }
                }
            }
        })
    }
    
    func logIn(with user: User) {
        gigController?.signIn(with: user, completion: { (error) in
            if let error = error {
                NSLog("Error occurred during sign in: \(error)")
            } else {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        })
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

enum LoginType {
    case logIn
    case signUp
}
