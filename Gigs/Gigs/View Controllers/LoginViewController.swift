//
//  LoginViewController.swift
//  Gigs
//
//  Created by Niranjan Kumar on 10/30/19.
//  Copyright © 2019 Nar Kumar. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case signIn
    
}

class LoginViewController: UIViewController {
   
    // MARK: - Outlets
    
    @IBOutlet weak var loginSegment: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    
    // MARK: - Properties
    
    var gigController: GigController?
    var loginType: LoginType = .signIn // question why this would work here but not in a switch statement
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        enterButton.layer.cornerRadius = 8.0
    }
    
    // MARK: - Action Handlers
    
    @IBAction func loginSegmentChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            loginType = .signUp
            enterButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .signIn
            enterButton.setTitle("Sign In", for: .normal)
        }
    }
    
    @IBAction func enterButtonTapped(_ sender: UIButton) {
        guard let gigController = gigController else { return }
        guard let username = usernameTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        let user = User(username: username, password: password)
        
        if loginType == .signUp {
            gigController.signUp(with: user) { (error) in
                if let error = error {
                    print("Error occured during sign up: \(error)")
                } else {
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: "Congrats on Signing Up!", message: "Please Sign In", preferredStyle: .alert)
                        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                        
                        alertController.addAction(action)
                        self.present(alertController, animated: true) {
                            self.loginType = .signIn
                            self.loginSegment.selectedSegmentIndex = 1
                            self.enterButton.setTitle("Sign In", for: .normal)
                            
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
