//
//  LoginViewController.swift
//  GigsApp
//
//  Created by Bhawnish Kumar on 4/7/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.
//

import UIKit

enum LoginType: String {
    case signUp = "Sign Up"
    case signIn = "Sign In"
}
class LoginViewController: UIViewController {
   
    
    @IBOutlet weak var userTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var signUpButton: UIButton!
    
  var gigController: GigController?
  var loginType = LoginType.signUp
    lazy var viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginSegmentControlAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1:
            loginType = .signIn
            passwordTextField.textContentType = .password
        default:
            loginType = .signUp
            passwordTextField.textContentType = .newPassword
        }
        signUpButton.setTitle(loginType.rawValue, for: .normal)
        
    }
    
    
    @IBAction func SignUpButtonTapped(_ sender: Any) {
        
        guard let username = userTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            username.isEmpty == false,
            let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            password.isEmpty == false
            else { return }
        let user = User(username: username, password: password)
        
       viewModel.submit(with: user, forLoginType: loginType) { loginResult in
                   DispatchQueue.main.async {
                       let alert: UIAlertController
                       let action: () -> Void // it's going to do whatever you passed to it.
                       
                       switch loginResult {
                       case .signUpSuccess:
                        alert = self.alert(title: "Success", message: loginResult.rawValue)
                           action = {
                            self.present(alert, animated: true)
                               self.loginSegmentedControl.selectedSegmentIndex = 1
                               self.loginSegmentedControl.sendActions(for: .valueChanged) // act like if thhe user tpaped on you.
                           }
                        
                       case .signInSuccess:
                           action = { self.dismiss(animated: true , completion: nil)}
                       
                       case .signUpError, .signInError:
                           alert = self.alert(title: "Error", message: loginResult.rawValue)
                           action = { self.present(alert, animated: true)}
                           
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
    
        

}
