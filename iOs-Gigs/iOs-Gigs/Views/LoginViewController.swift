//
//  LoginViewController.swift
//  iOs-Gigs
//
//  Created by Sal Amer on 1/21/20.
//  Copyright © 2020 Sal Amer. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case signIn
}

class LoginViewController: UIViewController {

    var gigController: GigController!
    var loginType = LoginType.signUp
    //IB Outlets
    
    @IBOutlet weak var signInSegmentSwitch: UISegmentedControl!
    @IBOutlet weak var usernameTxtFld: UITextField!
    @IBOutlet weak var passwordTxtFld: UITextField!
    @IBOutlet weak var signinBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signinBtn.backgroundColor = UIColor(hue: 190/360, saturation: 70/100, brightness: 80/100, alpha: 1.0)
                   signinBtn.tintColor = .white
                   signinBtn.layer.cornerRadius = 8.0
        // Do any additional setup after loading the view.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //IB Actions\
    
       @IBAction func loginBtnPressed(_ sender: Any) {
        // perform login or sign up operation based on loginType
               guard let gigController = gigController else { return }
               guard let username = usernameTxtFld.text,
                   !username.isEmpty,
                   let password = passwordTxtFld.text,
                   !password.isEmpty else { return }
              
               let user = User(username: username, password: password)
               
               if loginType == .signUp {
                   gigController.signUp(with: user) { (error) in
                       if let error = error {
                           print("Error Occured during signup: \(error)")
                       } else {
                           DispatchQueue.main.async {
                               let alertController = UIAlertController(title: "Sign Up Successful", message: "Now please sign in", preferredStyle: .alert)
                               let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                               alertController.addAction(alertAction)
                               self.present(alertController, animated: true) {
                                   self.loginType = .signIn
                                   self.signInSegmentSwitch.selectedSegmentIndex = 1
                                   self.signinBtn.setTitle("Sign In", for: .normal)
                               }
                           }
                       }
                   }
               } else {
                   gigController.signIn(with: user) { (error) in
                       if let error = error {
                           print("Error Occured during sign in: \(error)")
                       } else {
                           DispatchQueue.main.async {
                               self.dismiss(animated: true, completion: nil)
                           }
                       }
                   }
               }
       }
    
    
    @IBAction func signInSegmentSwitched(_ sender: UISegmentedControl) {
        // switch UI between login types
               if sender.selectedSegmentIndex == 0 {
                   loginType = .signUp
                   signinBtn.setTitle("Sign Up", for: .normal)
               } else {
                   loginType = .signIn
                   signinBtn.setTitle("Sign In", for: .normal)
               }
    }
   
    
}
