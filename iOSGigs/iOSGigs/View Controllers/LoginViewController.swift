//
//  LoginViewController.swift
//  iOSGigs
//
//  Created by Aaron Peterson on 5/11/20.
//  Copyright © 2020 Aaron Peterson. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var segmentedController: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    var gigController: GigController?
    var loginType = LoginType.signUp
    
    enum LoginType {
        case signUp
        case signIn
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signUpButton.backgroundColor = UIColor(hue: 190/360, saturation: 70/100, brightness: 80/100, alpha: 1.0)
        signUpButton.tintColor = .white
        signUpButton.layer.cornerRadius = 8.0

        // Do any additional setup after loading the view.
    }
    
    // MARK: - IBActions
    
    @IBAction func segmentedControllerSwitch(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            loginType = .signUp
            signUpButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .signIn
            signUpButton.setTitle("Sign In", for: .normal)
        }
        
    }
    
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        if let username = usernameTextField.text, !username.isEmpty, let password = passwordTextField.text, !password.isEmpty {
            let user = User(username: username, password: password)
            if loginType == .signUp {
                
                gigController?.signUp(with: user, completion: { (result) in
                    do {
                        let success = try result.get()
                        if success {
                            DispatchQueue.main.async {
                                let alertController = UIAlertController(title: "Sign Up Successful", message: "Now please log in", preferredStyle: .alert)
                                let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                alertController.addAction(alertAction)
                                self.present(alertController, animated: true) {
                                    self.loginType = .signIn
                                    self.segmentedController.selectedSegmentIndex = 1
                                    self.signUpButton.setTitle("Sign In", for: .normal)
                                }
                            }
                        }
                    } catch {
                        print("Error signing up: \(error)")
                    }
                })
            } else {
                gigController?.signIn(with: user, completion: { (result) in
                    do {
                        let success = try result.get()
                        if success {
                            DispatchQueue.main.async {
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                    } catch {
                        if let error = error as? GigController.NetworkError {
                            switch error {
                            case .failedSignIn:
                                print("Signed in failed")
                            case .noToken, .noData:
                                print("No data received")
                            default:
                                print("Other error occurred")
                            }
                        }
                    }
                })
            }
        }
    }
    

}
