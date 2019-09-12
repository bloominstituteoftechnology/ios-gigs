//
//  LoginViewController.swift
//  ios-gigs
//
//  Created by Aaron on 9/10/19.
//  Copyright © 2019 AlphaGrade, INC. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var logInSignUpButton: UIButton!
    
    var mode: Status = .signUp
    var gigController = GigController()
    var myUser: User?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    

    
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
                        } else {
                            DispatchQueue.main.async {
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                    })
                }
            }
    
    }
    
    @IBAction func segmentControllerToggled(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            mode = .signUp
            logInSignUpButton.setTitle("Sign Up", for: .normal)
        } else if sender.selectedSegmentIndex == 1 {
            mode = .signIn
            logInSignUpButton.setTitle("Sign In", for: .normal)
        }
    }
    
    func alert(with title: String, and message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(alertAction)
        present(alert, animated: true)
    }
 

}
