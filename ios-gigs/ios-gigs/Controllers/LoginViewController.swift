//
//  LoginViewController.swift
//  ios-gigs
//
//  Created by Aaron on 9/10/19.
//  Copyright © 2019 AlphaGrade, INC. All rights reserved.
//

import UIKit

protocol loginViewControllerDelegate: AnyObject {
    func loginSucessful(_ loginWasASuccess: Bool)
}

class LoginViewController: UIViewController {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var logInSignUpButton: UIButton!
    
    var mode: Status = .signUp
    var gigController = GigController()
    var myUser: User?
    weak var delegate: loginViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    

    // Triggers when Log In / Sign Up button is pressed
    @IBAction func buttonPressed(_ sender: Any) {
        guard let user = userTextField.text, let pass = passTextField.text else { return }
        let myUser = User(username: user, password: pass)
        if !user.isEmpty && !pass.isEmpty {
            if mode == .signUp {
                gigController.signUp(with: myUser) { (error) in
                    if let error = error {
                        print("Sign Up Error: \(error)")
                    } else {
                        DispatchQueue.main.async {
                            self.alert(with: "Sign Up Successful", and: "Please Log In.")
                                self.segmentControl.selectedSegmentIndex = 1
                                self.mode = .signIn
                                self.logInSignUpButton.setTitle("Sign In", for: .normal)
                            }
                        }
                    }
                } else {
                    gigController.signIn(with: myUser, completion: { (error) in
                        if let error = error {
                            print("Sign In Error: \(error)")
                            DispatchQueue.main.async {
                                self.alert(with: "Login Error", and: "Username or password is incorrect, or the account doesn't exist. Try again. \(error)")
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.delegate?.loginSucessful(true)
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                    })
                }
            }
    
    }
    
    // Controls the Segment controller for the Sign in / Sign up modes.
    @IBAction func segmentControllerToggled(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            mode = .signUp
            logInSignUpButton.setTitle("Sign Up", for: .normal)
        } else if sender.selectedSegmentIndex == 1 {
            mode = .signIn
            logInSignUpButton.setTitle("Sign In", for: .normal)
        }
    }
    
    // Alert Function for various messages when logging in.
    func alert(with title: String, and message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(alertAction)
        present(alert, animated: true)
    }
 
}
