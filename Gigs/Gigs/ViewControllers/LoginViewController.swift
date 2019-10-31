//
//  LoginViewController.swift
//  Gigs
//
//  Created by Rick Wolter on 10/30/19.
//  Copyright © 2019 Richar Wolter. All rights reserved.
//

import UIKit

enum LoginType{
    case loggingIn
    case signingUp
}

class LoginViewController: UIViewController {
    
    
    
    var gigController: GigController?
    var loginType = LoginType.signingUp
    
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var logInTypeSegment: UISegmentedControl!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func segmentToggled(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            loginType = .signingUp
            button.setTitle("Sign Up", for: .normal)
        }
        if sender.selectedSegmentIndex == 1 {
            loginType = LoginType.loggingIn
            button.setTitle("Log In", for: .normal)
        }
        
        
        
    }
    
    @IBAction func buttonClicked(_ sender: UIButton) {
        
         guard let gigController = gigController else { return }
               guard let username = userNameTextField.text,
                   !username.isEmpty,
                   let password = userPasswordTextField.text,
                   !password.isEmpty else { return }
               
               let user = User(username: username, password: password)
               
        if loginType == .signingUp {
                   gigController.signUp(with: user) { error in
                       if let error = error {
                           print("Error occurred during sign up: \(error)")
                       } else {
                           DispatchQueue.main.async {
                               let alertController = UIAlertController(title: "Sign Up Successful", message: "Now please sign in.", preferredStyle: .alert)
                               let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                               alertController.addAction(alertAction)
                               self.present(alertController, animated: true) {
                                self.loginType = .signingUp
                                   self.logInTypeSegment.selectedSegmentIndex = 1
                                   self.button.setTitle("Sign In", for: .normal)
                               }
                           }
                       }
                   }
               } else {
                   gigController.signIn(with: user) { error in
                       if let error = error {
                           print("Error occurred during sign in: \(error)")
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
