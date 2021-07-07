//
//  LoginViewController.swift
//  iOS-Gigs
//
//  Created by Aaron Cleveland on 1/22/20.
//  Copyright © 2020 Aaron Cleveland. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case signIn
}

class LoginViewController: UIViewController {

    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var buttonLabel: UIButton!
    
    var gigController: GigController!
    var loginType = LoginType.signUp
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func segmentControlTapped(_ sender: Any) {
        if segmentControl.selectedSegmentIndex == 0 {
            loginType = .signUp
            buttonLabel.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .signIn
            buttonLabel.setTitle("Sign In", for: .normal)
        }
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        guard let gigController = gigController else { return }
        if let username = usernameLabel.text,
            !username.isEmpty,
            let password = passwordLabel.text,
            !password.isEmpty {
            let user = User(username: username, password: password)
            
            if loginType == .signUp {
                gigController.signUp(with: user) { (error) in
                    if let error = error {
                        print("Error occured during signup: \(error)")
                    } else {
                        DispatchQueue.main.async {
                            let alertController = UIAlertController(title: "Sign Up Successful", message: "Now please login.", preferredStyle: .alert)
                            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alertController.addAction(alertAction)
                            self.present(alertController, animated: true) {
                                self.loginType = .signIn
                                self.segmentControl.selectedSegmentIndex = 1
                                self.buttonLabel.setTitle("Sign In", for: .normal)
                            }
                        }
                    }
                }
            } else {
                gigController.signIn(with: user) { (error) in
                    if let error = error {
                        print("Error occured \(error)")
                    } else {
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
}
