//
//  LoginViewController.swift
//  iOS Gigs
//
//  Created by Brandi on 10/30/19.
//  Copyright © 2019 Brandi. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case signIn
}

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    var gigController: GigController!
    var loginType = LoginType.signUp

    @IBOutlet weak var signInSegmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        signInButton.backgroundColor = UIColor(hue: 195/360, saturation: 93/100, brightness: 44/100, alpha: 1.0)
            signInButton.tintColor = .white
            signInButton.layer.cornerRadius = 4.0
        // Do any additional setup after loading the view.
    }
    
    @IBAction func segementedControlChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            loginType = .signUp
            signInButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .signIn
            signInButton.setTitle("Sign In", for: .normal)
        }
    }
    
    @IBAction func signinButtonTapped(_ sender: UIButton) {
        // perform login or sign up operation based on loginType
        guard let gigController = gigController else { print("Tapped")
            return }
        guard let username = usernameTextField.text,
            !username.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty else { return }
        
        let user = User(username: username, password: password)
        
        if loginType == .signUp {
            gigController.signUp(with: user) { error in
                if let error = error {
                    print("Error occurred during sign up: \(error)")
                } else {
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: "Sign Up Successful", message: "Please Sign In", preferredStyle: .alert)
                        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(alertAction)
                        self.present(alertController, animated: true) {
                            self.loginType = .signIn
                            self.signInSegmentedControl.selectedSegmentIndex = 1
                            self.signInButton.setTitle("Sign In", for: .normal)
                        }
                    }
                }
            }
        } else {
            print("We are here")
            gigController.signIn(with: user) { error in
                if let error = error {
                    print("Error occured during sign in: \(error)")
                } else {
                    print("Now we're here...")
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                        print("And finally here.")
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
