//
//  LoginViewController.swift
//  gigs
//
//  Created by John McCants on 7/17/20.
//  Copyright © 2020 John McCants. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    enum LoginOptions {
        case signUp
        case signIn
    }
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpInButton: UIButton!
    
    var gigController: GigController?
    var loginOption = LoginOptions.signUp
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func segmentChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            loginOption = .signUp
            signUpInButton.setTitle("Sign Up", for: .normal)
        
        case 1:
            loginOption = .signIn
            signUpInButton.setTitle("Sign In", for: .normal)
        default:
            break
        }
    }
    @IBAction func buttonTapped(_ sender: UIButton) {
        
        guard let username = usernameTextField.text, !username.isEmpty, let password = passwordTextField.text, !password.isEmpty, let gigController = gigController else {
            return
            }
        let user = User(username: username, password: password)
        
        switch loginOption {
        case .signUp:
            gigController.signUp(with: user, completion: { (result) in
                do {
                    let success = try result.get()
                    if success {
                        DispatchQueue.main.async {
                            self.loginOption = .signIn
                            self.segmentedControl.selectedSegmentIndex = 1
                            self.signUpInButton.setTitle("Sign In", for: .normal)
                        }
                    }
                } catch {
                    print("Error sign up")
                }
            })
        case .signIn:
            gigController.signIn(with: user, completion: {(result)
                in
                do {
                    let success = try result.get()
                    if success {
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                            print("Sign In Succesful")
                        }
                    }
                } catch {
                    print("unable to sign in")
                }
            })
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


