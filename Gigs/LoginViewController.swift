//
//  LoginViewController.swift
//  Gigs
//
//  Created by Lambda_School_Loaner_201 on 11/5/19.
//  Copyright © 2019 Christian Lorenzo. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case signIn
}

class LoginViewController: UIViewController {
    
    var gigController: GigController?
    
    var loginType = LoginType.signUp
    
    
    @IBOutlet weak var segmentedLoginSignUp: UISegmentedControl!
    
    @IBOutlet weak var usernameOutlet: UITextField!
    
    @IBOutlet weak var passwordOutlet: UITextField!
    
    @IBOutlet weak var signUpSignInOutlet: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // if signed in before then just segue UserDefaults.standard.set(password )
        segmentedLoginSignUp.selectedSegmentIndex = 0
        signUpSignInOutlet.setTitle("SignUp", for: .normal)
        //else
    }
    

    
    
    @IBAction func signInSignUpAction(_ sender: UIButton) {
      
        //Perform login or sign up operation based on loginType
        guard let gigController = gigController else {return}
          print("You Tapped me")
        if let username = usernameOutlet.text,
            !username.isEmpty,
            let password = passwordOutlet.text,
            !password.isEmpty {
            let user = User(username: username, password: password)
            
            
            if loginType == .signUp {
                gigController.signUp(with: user) { (error) in
                    if let error = error {
                        print("Error occurred during sign up: \(error)")
                    }else {
                        DispatchQueue.main.async {
                            let alertController = UIAlertController(title: "Sign Up Successful", message: "Now Please Log in", preferredStyle: .alert)
                            let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                            alertController.addAction(alertAction)
                            self.present(alertController, animated: true) {
                                self.loginType = .signIn
                                
                                self.segmentedLoginSignUp.selectedSegmentIndex = 1
                                self.signUpSignInOutlet.setTitle("Sign in", for: .normal)
                            }
                        }
                    }
                }
            }else {
                //Run Sign in API call
                gigController.signIn(with: user) { (error) in
                    if let error = error {
                        print("Error occurred during sign up \(error)")
                    }else {
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func segmentedLoginSignupAction(_ sender: UISegmentedControl) {
        //Switch UI between login types:
        if sender.selectedSegmentIndex == 0 {
            loginType = .signUp
            signUpSignInOutlet.setTitle("Sign Up", for: .normal)
        }else {
            loginType = .signIn
            signUpSignInOutlet.setTitle("Sign In", for: .normal)
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
