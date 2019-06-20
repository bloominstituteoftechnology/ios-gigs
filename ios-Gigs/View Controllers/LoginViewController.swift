//
//  LoginViewController.swift
//  ios-Gigs
//
//  Created by Kat Milton on 6/19/19.
//  Copyright © 2019 Kat Milton. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case signIn
}

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var signInSegment: UISegmentedControl!
    @IBOutlet var signInButton: UIButton!
    
    var gigController: GigController!
    var loginType = LoginType.signUp

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        signInButton.backgroundColor = UIColor(hue: 190/360, saturation: 70/100, brightness: 80/100, alpha: 1.0)
        signInButton.tintColor = .white
        signInButton.layer.cornerRadius = 8.0
    }
    
    @IBAction func signInSegmentChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            // 0 = sign up
            loginType = .signUp
            signInButton.setTitle("Sign Up", for: .normal)
        } else {
            // 1 = sign in
            loginType = .signIn
            signInButton.setTitle("Sign In", for: .normal)
        }
    }
    
    
    @IBAction func signInButtonPressed(_ sender: UIButton) {
        guard let gigController = gigController else { return }
        if let username = usernameTextField.text,
            !username.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty {
            let user = User(username: username, password: password)
            if loginType == .signUp {
                gigController.signUp(with: user) { error in
                    if let error = error {
                        print("Error occurred during sign up: \(error)")
                    } else {
                        DispatchQueue.main.async {
                            let alertController = UIAlertController(title: "Sign up successful!", message: "Now please log in.", preferredStyle: .alert)
                            let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                            alertController.addAction(alertAction)
                            self.present(alertController, animated: true, completion: {
                                self.loginType = .signIn
                                self.signInSegment.selectedSegmentIndex = 1
                                self.signInButton.setTitle("Sign In", for: .normal)
                            })
                        }
                    }
                }
            } else {
                gigController.signIn(with: user) { error in
                    if let error = error {
                        print("Error occurred during sign up: \(error)")
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
