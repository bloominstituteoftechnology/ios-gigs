//
//  LoginViewController.swift
//  Gigs
//
//  Created by Michael on 1/15/20.
//  Copyright © 2020 Michael. All rights reserved.
//

import UIKit
enum LoginType {
    case signUp
    case signIn
}

class LoginViewController: UIViewController {
    
    var gigController: GigController?
    
    var loginType = LoginType.signUp
    
    @IBOutlet weak var signUpOrInSegmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpOrInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            loginType = .signUp
            signUpOrInButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .signIn
            signUpOrInButton.setTitle("Sign In", for: .normal)
        }
    }
    
    @IBAction func signUpOrInButtonTapped(_ sender: UIButton) {
        guard let gigController = gigController else { return }
        if let username = usernameTextField.text, !username.isEmpty, let password = passwordTextField.text, !password.isEmpty {
            let user = User(username: username, password: password)
            
            if loginType == .signUp {
                gigController.signUp(with: user) { error in
                    if let error = error {
                        print("Error occured during sign up: \(error).")
                    } else {
                        DispatchQueue.main.async {
                            let alertController = UIAlertController(title: "Sign Up Successful!", message: "Please log in...", preferredStyle: .alert)
                            let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                            alertController.addAction(alertAction)
                            self.present(alertController, animated: true) {
                                self.loginType = .signIn
                                
                                self.signUpOrInSegmentedControl.selectedSegmentIndex = 1
                                self.signUpOrInButton.setTitle("Sign In", for: .normal)
                            }
                        }
                    }
                }
            } else {
                gigController.signIn(with: user) { error in
                    if let error = error {
                        print("Error occured during sign in: \(error).")
                    } else {
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }      
        }
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
