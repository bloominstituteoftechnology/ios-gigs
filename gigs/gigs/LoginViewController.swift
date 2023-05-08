//
//  LoginViewController.swift
//  gigs
//
//  Created by Harm on 5/5/23.
//

import UIKit

enum LoginType {
    case signUp
    case logIn
}

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    
    var loginType = LoginType.signUp
    var gigController: GigController?
    
    /*
     let decoder = JSONDecoder()
     decoder.decode([String: User].self, from: Foundation.Data)
     
     {
         "-NUxLhFgqu8MXpFQ_Gva":{
             "password":"Apple",
             "username":"Tim"
         },
         "-NUxMSlmkxxOo60qW0r2":{
             "password":"Apple",
             "username":"Tim"
         }
     }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        
        if let username = usernameTextField.text,
            !username.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty {
            let user = User(username: username, password: password)
            
            if loginType == .signUp {
                gigController?.signUp(with: user, completion: { result in
                    do {
                        let success = try result.get()
                        if success {
                            DispatchQueue.main.async {
                                let alertController = UIAlertController(title: "Sign Up Successful", message: "Now please log in.", preferredStyle: .alert)
                                let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                alertController.addAction(alertAction)
                                self.present(alertController, animated: true) {
                                    self.loginType = .logIn
                                    self.loginTypeSegmentedControl.selectedSegmentIndex = 1
                                    self.logInButton.setTitle("Log In", for: .normal)
                                }
                            }
                        }
                    } catch {
                        print("Error signing up: \(error)")
                    }
                })
            } else {
                // TODO: call signIn method on apiController with above user object
            }
            
        }
        
    }
    @IBAction func signInTypeChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            loginType = .logIn
            logInButton.setTitle("Log In", for: .normal)
        } else {
            loginType = .signUp
            logInButton.setTitle("Sign Up", for: .normal)
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
