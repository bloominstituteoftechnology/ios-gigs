//
//  LoginViewController.swift
//  Gigs
//
//  Created by admin on 10/2/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case signIn
}

class LoginViewController: UIViewController {
    
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    var gigController: GigController?
    
    var loginType = LoginType.signUp

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func signUp(with user: User) {
        gigController?.signUP(with: user, completion: { (error) in
            
            if let error = error {
                NSLog("Error occured during sign up: \(error)")
            } else {
                
                let alert = UIAlertController(title: "Sign Up Successful", message: "Now please log in", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                alert.addAction(okAction)
                
                DispatchQueue.main.async {
                    self.present(alert, animated: true) {
                        self.loginType = .signIn
                        self.segmentedControl.selectedSegmentIndex = 1
                        self.signUpButton.setTitle("Sign In", for: .normal)
                    }
                }
            }
        })
    }
    
    func signIn(with user: User) {
        gigController?.signIn(with: user, completion: { (error) in
            
            if let error = error {
                NSLog("Error occured druing sign in: \(error)")
            } else {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        })
    }
    
    @IBAction func changedSegmentControl(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            loginType = .signUp
            signUpButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .signIn
            signUpButton.setTitle("Sign In", for: .normal)
        }
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        
        guard let username = usernameTextField.text,
            let password = passwordTextField.text,
            !username.isEmpty,
            !password.isEmpty else { return }
        
        let user = User(username: username, password: password)
        
        if loginType == .signUp {
            signUp(with: user)
        } else {
            signIn(with: user)
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
