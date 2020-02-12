//
//  LoginViewController.swift
//  Gigs
//
//  Created by Ufuk Türközü on 12.02.20.
//  Copyright © 2020 Ufuk Türközü. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case signIn
}

class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var loginTypeSC: UISegmentedControl!
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    // MARK: - Properties
    var gigController: GigController?
    var loginType = LoginType.signUp
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Actions
    @IBAction func changeLoginType(_ sender: UISegmentedControl) {
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        
        guard let username = usernameTF.text,
            let password = passwordTF.text,
            !username.isEmpty,
            !password.isEmpty else { return }
              
        let user = User(username: username, password: password)
        
        if loginType == .signUp {
            signUp(with: user)
        } else {
            signIn(with: user)
        }
    }
    
    func signUp(with user: User) {
        gigController?.signUp(with: user, completion: { (error) in
            if let error = error {
                NSLog("Error during sign up. \(error)")
            } else {
                let alert = UIAlertController(title: "Sign Up Successful", message: "Now please log in", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                alert.addAction(okAction)
                DispatchQueue.main.sync {
                        self.present(alert, animated: true) {
                        self.loginType = .signIn
                        self.loginTypeSC.selectedSegmentIndex = 1
                        self.signInButton.setTitle("Sign In", for: .normal)
                    }
                }
            }
        })
    }
    
    func signIn(with user: User) {
        gigController?.signIn(with: user, completion: { (error) in
            if let error = error {
                NSLog("Error during sign in: \(error)")
            } else {
                DispatchQueue.main.sync {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        })
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
