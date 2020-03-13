//
//  LoginViewController.swift
//  Gigs
//
//  Created by Bradley Diroff on 3/11/20.
//  Copyright © 2020 Bradley Diroff. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case signIn
}

class LoginViewController: UIViewController {

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var segmentButton: UISegmentedControl!
    @IBOutlet var signButton: UIButton!
    
    var gigController: GigController?
    var loginType = LoginType.signUp
    
    override func viewDidLoad() {
        super.viewDidLoad()

        signButton.layer.cornerRadius = 15.0
    }
    
    @IBAction func changeSegment(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            // this is sign up
            loginType = .signUp
            signButton.setTitle("Sign Up", for: .normal)
        } else {
            // this is sign in
            loginType = .signIn
            signButton.setTitle("Sign In", for: .normal)
        }
    }
    
    @IBAction func didTapSignButton(_ sender: Any) {
        if let username = nameTextField.text,
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
                                  self.segmentButton.selectedSegmentIndex = 1
                                  self.signButton.setTitle("Sign In", for: .normal)
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
        } else {
            print("Something fucked up")
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
