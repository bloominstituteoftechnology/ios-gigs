//
//  LoginViewController.swift
//  Gigs
//
//  Created by Bhawnish Kumar on 3/12/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.
//

import UIKit
enum LoginType {
    case signUp
    case signIn
}

class LoginViewController: UIViewController {

    
    @IBOutlet weak var segmentedOutlet: UISegmentedControl!
    @IBOutlet weak var buttonTapped: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userTextField: UITextField!
    
    var gigController: GigController?
    var loginType = LoginType.signUp

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func segmentedControl(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
               loginType = .signUp
               buttonTapped.setTitle("Sign Up", for: .normal)
           } else {
               loginType = .signIn
                buttonTapped.setTitle("Sign In", for: .normal)
           }
    }
    
    @IBAction func buttonAction(_ sender: Any) {
        if let username = userTextField.text,
                         !username.isEmpty,
                         let password = passwordTextField.text,
                         !password.isEmpty {
                         let user = User(username: username, password: password)
                         
                         if loginType == .signUp {
                             gigController?.signUp(with: user, completion: { error in
                                 if let error = error {
                                     NSLog("Error occurred during sign up: \(error)")
                                 } else {
                                     DispatchQueue.main.async {
                                         let alertController = UIAlertController(title: "Sign Up Successful", message: "Now please log in.", preferredStyle: .alert)
                                         let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                         alertController.addAction(alertAction)
                                         self.present(alertController, animated: true) {
                                             self.loginType = .signIn
                                             self.segmentedOutlet.selectedSegmentIndex = 1
                                             self.buttonTapped.setTitle("Sign In", for: .normal)
                                         }
                                     }
                                 }
                             })
                         } else {
                             // user wants to sign in
                             gigController?.signIn(with: user, completion: { error in
                                 if let error = error {
                                     NSLog("Error occurred during sign in: \(error)")
                                 } else {
                                     DispatchQueue.main.async {
                                         self.dismiss(animated: true, completion: nil)
                                     }
                                 }
                             })
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
