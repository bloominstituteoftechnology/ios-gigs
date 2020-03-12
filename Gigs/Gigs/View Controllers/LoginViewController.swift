//
//  LoginViewController.swift
//  Gigs
//
//  Created by Mark Gerrior on 3/11/20.
//  Copyright © 2020 Mark Gerrior. All rights reserved.
//

import UIKit

enum LoginType: Int {
    case signUp = 0
    case logIn
}

class LoginViewController: UIViewController {

    // MARK: - Properites
    var gigController: GigController?
    
    var loginType = LoginType.signUp {
        didSet {
            switch loginType {
            case .signUp:
                credentialsMode.selectedSegmentIndex = 0
                credentialsButtonLabel.setTitle("Sign Up", for: .normal)
            case .logIn:
                credentialsMode.selectedSegmentIndex = 1
                credentialsButtonLabel.setTitle("Log In", for: .normal)
            }
        }
    }

    // MARK: - Outlets
    
    @IBOutlet weak var credentialsMode: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var credentialsButtonLabel: UIButton!
    
    // MARK: - Actions
    
    /// User has pressed the segmented control to choose between Sign Up and Log In
    @IBAction func selectModeButton(_ sender: Any) {
        // I prefer to check selectedSegmentIndex vs. loginType because
        // I don't trust that I can know the state of the control 100% of the time
        if let newState = LoginType(rawValue: credentialsMode.selectedSegmentIndex) {
            loginType = newState
        }
    }
    
    /// User has pressed the action button to either Sign Up or Log In
    @IBAction func credentialsButton(_ sender: Any) {
        // perform login or sign up operation based on loginType
        guard let username = usernameTextField.text,
            !username.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty else { return }

        let user = User(username: username, password: password)
        
        if loginType == .signUp {
            gigController?.signUp(with: user, completion: { error in
                if let error = error {
                    NSLog("Error occurred during signup \(error)")
                } else {
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: "Sign up successful",
                                                                message: "Now please login",
                                                                preferredStyle: .alert)
                        
                        let alertAction = UIAlertAction(title: "OK",
                                                        style: .default) { _ in
                            self.loginType = .logIn
                            self.credentialsMode.selectedSegmentIndex = self.loginType.rawValue
                            self.credentialsButtonLabel.setTitle("Log In", for: .normal)
                            print("UIAlertAction closure has been called. Has OK been clicked? Yes!")
                        }

                        alertController.addAction(alertAction)

                        print("Sign Up was successful.")

                        self.present(alertController, animated: true) {
                            print("present closure has been called. Has OK been clicked? No")
                        }
                    }
                }
            })
        } else { // .logIn
            gigController?.signIn(with: user, completion: { error in
                if let error = error {
                    NSLog("Error occurred during sign in: \(error)")
                } else {
                    DispatchQueue.main.async {
                        print("Log In was successful.")
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            })
        }
    }
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}
