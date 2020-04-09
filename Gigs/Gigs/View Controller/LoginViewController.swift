//
//  LoginViewController.swift
//  Gigs
//
//  Created by Nichole Davidson on 4/7/20.
//  Copyright © 2020 Nichole Davidson. All rights reserved.
//

import UIKit

enum LoginType: String {
    case signUp = "Sign Up"
    case login = "Login"
}

class LoginViewController: UIViewController {
    
    static let identifier: String = String(describing: LoginViewController.self)
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var signUpButton: UIButton!
    
    var gigController: GigController?
    var loginType = LoginType.signUp
    lazy var viewModel = LoginViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func segmentedControlTapped(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1:
            loginType = .login
            passwordTextField.textContentType = .password
        default:
            loginType = .signUp
            passwordTextField.textContentType = .newPassword
        }
        
        signUpButton.setTitle(loginType.rawValue, for: .normal)
    }
    
    @IBAction func textDidChange(_ sender: UITextField) {
          // TODO: set enabled state for button
      }
    
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        guard let username = usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
        username.isEmpty == false,
            let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
        password.isEmpty == false
            else { return }
        
       let user = User(username: username, password: password)
       
       viewModel.submit(with: user, forLoginType: loginType) { loginResult in
           DispatchQueue.main.async {
               let alert: UIAlertController
               let action: () -> Void
               
               switch loginResult {
               case .signUpSuccess:
                   alert = self.alert(title: "Success", message: loginResult.rawValue)
                   action = {
                       self.present(alert, animated: true)
                       self.segmentedControl.selectedSegmentIndex = 1
                       self.segmentedControl.sendActions(for: .valueChanged)
                   }
               case .loginSuccess:
                   action = { self.dismiss(animated: true)}
               case .signUpError, .loginError:
                   alert = self.alert(title: "Error", message: loginResult.rawValue)
                   action = { self.present(alert, animated: true) }
               }
               
               action()
           }
       }
                     
    }
    
    private func alert(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        return alert
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
