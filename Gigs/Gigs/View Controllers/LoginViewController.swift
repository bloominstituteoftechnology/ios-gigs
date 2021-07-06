//
//  LoginViewController.swift
//  Gigs
//
//  Created by Sammy Alvarado on 7/11/20.
//  Copyright © 2020 Sammy Alvarado. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case signIn
}

class LoginViewController: UIViewController {

    @IBOutlet weak var signUpSegment: UISegmentedControl!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passWord: UITextField!
    @IBOutlet weak var signUpButton: UIButton!

    var gigController: GigiController?
    var loginType = LoginType.signUp
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func signUpButtonTapped(_ sender: Any) {
        if let username = userNameTextField.text,
            !username.isEmpty,
            let password = passWord.text,
            !password.isEmpty {
            let user = User(username: username, password: password)

            switch loginType {
            case .signUp:
                gigController?.signUP(with: user, completion: { (result) in
                    do {
                        let success = try result.get()
                        if success {
                            DispatchQueue.main.async {
                                let alertController = UIAlertController(title: "Sing Up Successful", message: "Now you can Sign In!", preferredStyle: .alert)
                                let alertAction = UIAlertAction(title: "Done", style: .default, handler: nil)
                                alertController.addAction(alertAction)
                                self.present(alertController, animated: true) {
                                    self.loginType = .signIn
                                    self.signUpSegment.selectedSegmentIndex = 1
                                    self.signUpButton.setTitle("Sign In", for: .normal)
                                }
                            }
                        }
                    } catch {
                        print("Error signing up: \(error)")
                    }
                })
            case .signIn:
                gigController?.signIn(with: user, completion: { (result) in
                    do {
                        let success = try result.get()
                        if success {
                            DispatchQueue.main.async {
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                    } catch {
                        if let error = error as? GigiController.NetWorkError {
                            switch error {
                            case .failedSignIn:
                                print("Sign in Failed")
                            case .noData, .noToKen:
                                print("No data received")
                            default:
                                print("Other error Occurred")
                            }
                        }
                    }
                })
            }
        }
    }

    @IBAction func signInTypeChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            loginType = .signUp
            signUpButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .signIn
            signUpButton.setTitle("Sign In", for: .normal)
        }
    }
}
