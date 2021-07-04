//
//  LoginViewController.swift
//  GigsHW
//
//  Created by Michael Flowers on 5/9/19.
//  Copyright © 2019 Michael Flowers. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case logIn
}

class LoginViewController: UIViewController {
    var gc: GigController?
    var loginType = LoginType.signUp

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var buttonProperties: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func segmentedValueChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            //this is the sign in ui
            loginType = .signUp
            buttonProperties.setTitle("Sign In", for: .normal)
        } else {
            loginType = .logIn
            buttonProperties.setTitle("Login", for: .normal)
        }
    }
    
    @IBAction func signUpButtonChanged(_ sender: UIButton) {
        
        guard let name = usernameTF.text, !name.isEmpty, let password = passwordTF.text, !password.isEmpty, let gc = gc else { return }
        let user = User(username: name, password: password)
        
        if loginType == .signUp {
            gc.signUp(with: user) { (error) in
                if let error = error {
                    print("Error calling the sign in function: \(error)")
                    return
                }
                
                DispatchQueue.main.async {
                    self.loginType = .logIn
                    self.buttonProperties.setTitle("Log In", for: .normal)
                    self.segmentedControl.selectedSegmentIndex = 1
                }
            }
        } else if loginType == .logIn {
            gc.logIn(with: user) { (error) in
                if let error = error {
                    print("Error calling the log in function: \(error)")
                    return
                }
                
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
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
