//
//  LoginViewController.swift
//  ios gigs
//
//  Created by Thomas Sabino-Benowitz on 10/30/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case signIn
}

class LoginViewController: UIViewController {

    var gigController: GigController?
    var loginType = LoginType.signUp

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func buttonTapped1(_ sender: UIButton) {
        guard let gigController = gigController else { return }
               guard let username = usernameTextField.text,
                   !username.isEmpty,
                   let password = passwordTextField.text,
               !password.isEmpty else { return }
               
               let user = User(username: username, password: password)
               
               if loginType == .signUp {
                   gigController.signUp(with: user) { error in
                       if let error = error {
                           print("ERROR occurred during sign up: \(error)")
                       } else {
                           DispatchQueue.main.async {
                               let alertController = UIAlertController(title: "You've successfully signed up!", message: "Now, please sign in", preferredStyle: .alert)
                               let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                               alertController.addAction(alertAction)
                               self.present(alertController, animated: true) {
                                   self.loginType = .signIn
                                   self.segmentedControl.selectedSegmentIndex = 1
                                   self.signInButton.setTitle("SignIn", for: .normal)
                               }
                           }
                       }
                   }
               } else {
                   gigController.signIn(with: user) {error in
                       if let error = error {
                           print("An Error occurred during sign in \(error)")
                       } else {
                           DispatchQueue.main.async {
                               self.dismiss(animated: true, completion: nil)
                           }
                       }
                   }
               }
               
           }
    @IBAction func signInTypeChanged1(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            loginType = .signUp
        signInButton.setTitle("Sign Up", for: .normal)
        } else{
            loginType = .signIn
            signInButton.setTitle("Sign In", for: .normal)
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
