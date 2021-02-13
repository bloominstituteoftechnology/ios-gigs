//
//  LoginViewController.swift
//  gigs
//
//  Created by James McDougall on 2/11/21.
//

import UIKit

enum LoginType {
    case signUp
    case logIn
}

class LoginViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    
    var gigController: GigController?
    var loginType = LoginType.signUp
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        if segmentedControl.selectedSegmentIndex == 0 {
            loginType = .signUp
            logInButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .logIn
            logInButton.setTitle("Log In", for: .normal)
        }
    }
    
    @IBAction func logInButtonTapped(_ sender: UIButton) {
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
                                let alertController = UIAlertController(title: "Successful Sign Up!", message: "Now please Log In", preferredStyle: .alert)
                                let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                                alertController.addAction(alertAction)
                                self.present(alertController, animated: true) {
                                    self.loginType = .signUp
                                    self.segmentedControl.selectedSegmentIndex = 1
                                    self.logInButton.setTitle("Sign In", for: .normal)
                                }
                                
                            }
                        }
                    } catch {
                        print("Error signing up: \(error)")
                    }
                })
            }
            
        }
        
        
    }
    
    
}
