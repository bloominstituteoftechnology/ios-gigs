//
//  SignInViewController.swift
//  Gigs
//
//  Created by Joel Groomer on 9/10/19.
//  Copyright © 2019 julltron. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case signIn
}

class SignInViewController: UIViewController {

    // MARK: - Outloets
    @IBOutlet weak var segSignUpIn: UISegmentedControl!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnSignUpIn: UIButton!
    
    // MARK: Public Variables
    var gigController: GigController!
    
    // MARK: Private Variables
    private var loginType = LoginType.signUp { didSet { updateBtnTitle() } }
    
    // MARK: - View Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - Actions
    @IBAction func signUpInChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            loginType = .signUp
        } else {
            loginType = .signIn
        }
    }
    
    func updateBtnTitle() {
        if loginType == .signUp {
            btnSignUpIn.setTitle("Sign Up", for: .normal)
        } else {
            btnSignUpIn.setTitle("Sign In", for: .normal)
        }
    }
    
    @IBAction func signUpInButtonTapped(_ sender: Any) {
        guard let username = txtUsername.text, !username.isEmpty,
            let password = txtPassword.text, !password.isEmpty
        else { return }
        
        let user = User(username: username, password: password)
        if loginType == .signUp {
            gigController.signUp(with: user) { error in
                if let error = error {
                    print("Sign Up error: \(error)")
                    return
                }
                DispatchQueue.main.async {
                    self.segSignUpIn.selectedSegmentIndex = 1
                    self.loginType = .signIn
                    let alert = UIAlertController(title: "Sign Up Successful", message: "You may now sign in.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
        } else {
            gigController.signIn(with: user) { error in
                if let error = error {
                    print("Sign In error: \(error)")
                    return
                }
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}
