//
//  LoginViewController.swift
//  Gigs
//
//  Created by Bradley Yin on 8/7/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    enum LoginType{
        case signUp
        case signIn
    }

    @IBOutlet weak var loginSignupSegmentControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextFeild: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    var loginType: LoginType = .signUp
    
    var gigController: GigController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func segmentControlSelected(_ sender: Any) {
        if loginSignupSegmentControl.selectedSegmentIndex == 0 {
            loginType = .signUp
            signUpButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .signIn
            signUpButton.setTitle("Sign In", for: .normal)
        }
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        guard let username = usernameTextField.text, !username.isEmpty, let password = passwordTextFeild.text, !password.isEmpty else { return }
        if loginType == .signUp {
            gigController.signUp(with: username, password: password) { (error) in
                if let error = error{
                    print("Error logging in: \(error)")
                    return
                }
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Sign Up Successful", message: "Now please sign in", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        self.loginType = .signIn
                        self.loginSignupSegmentControl.selectedSegmentIndex = 1
                        self.signUpButton.setTitle("Sign In", for: .normal)
                    })
                    alert.addAction(okAction)
                    
                    self.present(alert, animated: true)
                }
            }
        }else{
            gigController.login(with: username, password: password, completion: { (error) in
                guard error == nil else { return }
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
                
            })
        }
    }
    
}
