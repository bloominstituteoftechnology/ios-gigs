//
//  LoginViewController.swift
//  Gigs
//
//  Created by Norlan Tibanear on 7/11/20.
//  Copyright © 2020 Norlan Tibanear. All rights reserved.
//

import UIKit


enum LoginType {
    case signUp
    case signIn
}


class LoginViewController: UIViewController {
    
    
    // Outlets
    @IBOutlet var segmentButton: UISegmentedControl!
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    
    
    var gigsController: GigsController?
    var loginType = LoginType.signUp
    

    override func viewDidLoad() {
        super.viewDidLoad()

        loginButton.backgroundColor = UIColor(hue: 190/360, saturation: 70/100, brightness: 80/100, alpha: 1.0)
        loginButton.tintColor = .white
        loginButton.layer.cornerRadius = 8.0
        loginButton.clipsToBounds = true
        
    }
    
    @IBAction func signInBtn(_ sender: UIButton) {
        
        if let username = usernameTextField.text, !username.isEmpty,
            let password = passwordTextField.text, !password.isEmpty {
            let user = User(username: username, password: password)
            
            switch loginType {
            case .signUp:
                gigsController?.signUp(with: user, completion: { (result) in
                    do {
                        let success = try result.get()
                        if success {
                            DispatchQueue.main.async {
                                self.loginType = .signIn
                                self.segmentButton.selectedSegmentIndex = 1
                                self.loginButton.setTitle("Sign In", for: .normal)
                            }
                        }
                    } catch {
                        print("Error signin up: \(error)")
                    }
                })
                
            case .signIn:
                gigsController?.signIn(with: user, completion: { (result) in
                    do {
                        let success = try result.get()
                        if success {
                            DispatchQueue.main.async {
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                    } catch {
                        print("Error with Network")
                    }
                })
                
            } // Switch
        }
        
    } //
    
    
    @IBAction func segmentTappedBtn(_ sender: UISegmentedControl) {
        // Switch UI between login types
        if sender.selectedSegmentIndex == 0 {
            loginType = .signUp
            loginButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .signIn
            loginButton.setTitle("Sign In", for: .normal)
        }
    }
    

} //
