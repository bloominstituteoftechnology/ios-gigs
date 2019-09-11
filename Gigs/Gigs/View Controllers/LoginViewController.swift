//
//  LoginViewController.swift
//  Gigs
//
//  Created by Dillon P on 9/10/19.
//  Copyright © 2019 Lambda iOSPT2. All rights reserved.
//

import UIKit

enum LoginType {
    case logIn
    case signUp
}


class LoginViewController: UIViewController {

    @IBOutlet weak var signInSignUpSelection: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInSignUpButton: UIButton!
    
    var gigController: GigController?
    var loginType: LoginType?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func loginSignUpSelected(_ sender: Any) {
        if signInSignUpSelection.selectedSegmentIndex == 0 {
            loginType = .signUp
            signInSignUpButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .logIn
            signInSignUpButton.setTitle("Sign In", for: .normal)
        }
    }
    
    
    @IBAction func loginSignUpButton(_ sender: Any) {
        guard let gigController = gigController else { return }
        
        if let username = usernameTextField.text,
            !username.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty {
            
            let user = User(username: username, password: password)
            
            gigController.signUp(with: user) { (error) in
                if let error = error {
                    print("Error occured during sign up: \(error)")
                } else {
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: "Sign Up Successful", message: "Now please log in.", preferredStyle: .alert)
                        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                        alertController.addAction(alertAction)
                        self.present(alertController, animated: true, completion: {
                            self.signInSignUpSelection.selectedSegmentIndex = 1
                            self.loginType = .logIn
                            self.signInSignUpButton.setTitle("Sign In", for: .normal)
                        })
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
