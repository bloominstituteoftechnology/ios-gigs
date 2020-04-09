//
//  LogInViewController.swift
//  Gigs
//
//  Created by Cameron Collins on 4/7/20.
//  Copyright © 2020 Cameron Collins. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController, GigControllerDelegate {
    
    enum LoginType {
        case login
        case signup
    }
    
    //Outlets
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func update() {
        dismiss(animated: true)
    }
    
    //Variables
    var gigController: GigController?
    var selectedType: LoginType = .login
    
    
    //Actions
    @IBAction func valueChanged(_ sender: UISegmentedControl) {
        if selectedType == .login {
            selectedType = .signup
        } else {
            selectedType = .login
        }
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        
       if selectedType == .login {
            print("Login Triggered")
            var user = User(username: nameTextField.text ?? "", password: passwordTextField.text ?? "")
            gigController?.userLogin(user: &user) {
                DispatchQueue.main.async {
                    if self.gigController?.bearer != nil {
                        self.dismiss(animated: true)
                    }
                }
            }
        } else {
            print("SignUp Triggered")
            var user = User(username: nameTextField.text ?? "", password: passwordTextField.text ?? "")
            gigController?.userSignup(user: &user) {
                DispatchQueue.main.async {
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
