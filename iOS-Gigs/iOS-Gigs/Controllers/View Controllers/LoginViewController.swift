//
//  LoginViewController.swift
//  iOS-Gigs
//
//  Created by Aaron Cleveland on 1/15/20.
//  Copyright © 2020 Aaron Cleveland. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case signIn
}

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signButtonLabel: UIButton!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    var auth: Auth?
    var loginType = LoginType.signUp
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func segmentControllerTapped(_ sender: UISegmentedControl) {
        if segmentControl.selectedSegmentIndex == 0 {
            loginType = .signUp
            signButtonLabel.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .signIn
            signButtonLabel.setTitle("Sign In", for: .normal)
        }
    }
    
    @IBAction func signButtonTapped(_ sender: UIButton) {
        guard let auth = auth else { return }
        if let username = usernameTextField.text,
            !username.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty {
            let user = User(username: username, password: password)
            
            if loginType == .signUp {
                //perform sign up
                auth.signUp(with: user) { error in
                    if let error = error {
                        print("error occured during sign up: \(error)")
                    } else {
                        DispatchQueue.main.async {
                            let alertController = UIAlertController(title: "Sign Up Successful", message: "Now please login.", preferredStyle: .alert)
                            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alertController.addAction(alertAction)
                            self.present(alertController, animated: true) {
                                self.loginType = .signIn
                                self.segmentControl.selectedSegmentIndex = 1
                                self.signButtonLabel.setTitle("Sign In", for: .normal)
                            }
                        }
                    }
                }
            } else {
                //perform sign in
                auth.signIn(with: user) { error in
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
