//
//  LoginViewController.swift
//  Gigs
//
//  Created by Gerardo Hernandez on 1/21/20.
//  Copyright © 2020 Gerardo Hernandez. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case signIn
}

class LoginViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var loginTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpSignInButton: UIButton!
    
    // MARK: - Properties
    var gigController: GigController!
    var loginType = LoginType.signUp
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signUpSignInButton.backgroundColor = UIColor(hue: 190/360, saturation: 70/100, brightness: 80/100, alpha: 1.0)
                   signUpSignInButton.tintColor = .white
                   signUpSignInButton.layer.cornerRadius = 8.0

        // Do any additional setup after loading the view.
    }
    
        // MARK: - Action Handlers

    @IBAction func loginSegementedState(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            loginType = .signUp
            signUpSignInButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .signIn
            signUpSignInButton.setTitle("Sign In", for: .normal)
        }
    }
    
    @IBAction func SignUpLoginButtonPressed(_ sender: UIButton) {
        guard let gigController = gigController else { return }
        guard let username = usernameTextField.text,
            !username.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty else { return }
        
        let user = User(username: username, password: password)
        
        if loginType == .signUp {
            gigController.signUp(with: user) { (error) in
                if let error = error {
                    print("Error occured during sign up: \(error)")
                } else {
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: "Sign Up Successful", message: "Now please sign in", preferredStyle: .alert)
                        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(alertAction)
                       
                        self.present(alertController, animated: true) {
                            self.loginType = .signIn
                            self.loginTypeSegmentedControl.selectedSegmentIndex = 1
                            self.signUpSignInButton.setTitle("Sign In", for: .normal)
                            
                }
            }
        }
        
    }
        } else {
            gigController.signIn(with: user) { (error) in
                if let error = error {
                print("Error occured during sign in: \(error)")
            } else {
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
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
