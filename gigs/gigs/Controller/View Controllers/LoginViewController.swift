//
//  LoginViewController.swift
//  gigs
//
//  Created by Kenny on 1/15/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    enum LoginType: String {
        case signIn
        case signUp
    }
    
    //MARK: IBOutlets
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    //MARK: IBActions
    @IBAction func loginMethodWasChanged(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            loginType = .signUp
            loginButton.setTitle("Sign Up", for: .normal)
        case 1:
            loginType = .signIn
            loginButton.setTitle("Sign In", for: .normal)
        default: fatalError("Only 2 segmented controls exist! Control #\(segmentedControl.selectedSegmentIndex) is out of range!")
        }
    }
    
    @IBAction func loginButtonWasTapped(_ sender: Any) {
        print(self.loginType)
        guard let usernameText = usernameTextField.text,
            usernameText != "",
            let passwordText = passwordTextField.text,
            passwordText != ""
        else {return}
        let user = User(username: usernameText, password: passwordText)
        
        if loginType == .signUp {
            gigController.signUp(with: user) { (error) in
                if let error = error {
                    print("Error signing up! \(error)")
                    return
                }
                //update UI
                DispatchQueue.main.async {
                    self.loginType = .signIn
                    self.segmentedControl.selectedSegmentIndex = 1
                    self.loginButton.setTitle("Sign In", for: .normal)
                    Alert.show(title: "Success!", message: "Account Created. Please Login", vc: self)
                }
            }
        } else {
            gigController.signIn(with: user) { (error) in
                if let error = error {
                    print(error)
                    return
                }
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    //MARK: Class Properties
    var gigController: GigController!
    var loginType = LoginType.signUp
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let customNavBarAppearance = NavBarAppearance.appearance()
        navigationController?.navigationBar.standardAppearance = customNavBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = customNavBarAppearance
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    

}
