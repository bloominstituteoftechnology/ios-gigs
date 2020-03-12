//
//  LoginViewController.swift
//  Gigs
//
//  Created by Lydia Zhang on 3/11/20.
//  Copyright © 2020 Lydia Zhang. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case signIn
}

class LoginViewController: UIViewController {
    
    var gigController: GigController?
    var loginType = LoginType.signUp
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var passWord: UITextField!
    @IBOutlet weak var loginTypeSegment: UISegmentedControl!
    @IBOutlet weak var signInBar: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signInBar.backgroundColor = UIColor(hue: 190/360, saturation: 70/100, brightness: 80/100, alpha: 1.0)
        signInBar.tintColor = .white
        signInBar.layer.cornerRadius = 8.0
    }
    
    
    @IBAction func segmentToggled(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            loginType = .signUp
            signInBar.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .signIn
            signInBar.setTitle("Sign In", for: .normal)
        }
    }
    
    
    
    @IBAction func signButtonTapped(_ sender: UIButton) {
        guard let gigController = gigController else { return }
        if let username = userName.text,!username.isEmpty,let password = passWord.text,!password.isEmpty {
            let user = User(username: username, password: password)
            if loginType == .signUp {
                gigController.signUp(with: user) { error in
                    if let error = error {
                        NSLog("Error occurred during sign up: \(error)")
                    } else {
                        DispatchQueue.main.async {
                            let alertController = UIAlertController(title: "Sign Up Successful", message: "Now please log in.", preferredStyle: .alert)
                            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alertController.addAction(alertAction)
                            self.present(alertController, animated: true) {
                                self.loginType = .signIn
                                self.loginTypeSegment.selectedSegmentIndex = 1
                                self.signInBar.setTitle("Sign In", for: .normal)
                            }
                        }
                    }
                }
            } else {
                gigController.signIn(with: user) { error in
                    if let error = error {
                        NSLog("Error occured during sign in: \(error)")
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
