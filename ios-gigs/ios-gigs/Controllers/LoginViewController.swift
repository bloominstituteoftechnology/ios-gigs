//
//  LoginViewController.swift
//  ios-gigs
//
//  Created by Aaron on 9/10/19.
//  Copyright © 2019 AlphaGrade, INC. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var logInSignUpButton: UIButton!
    
    var mode: Status = .signUp
    var gigController = GigController()
    var myUser: User?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? GigsTableViewController {
            vc.delegate = myUser
        }
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        guard let user = userTextField.text, let pass = passTextField.text else { return }
        var myUser = User(username: user, password: pass)
        if !user.isEmpty && !pass.isEmpty {
            if mode == .signIn {
                gigController.signUp(with: myUser) { (error) in
                    
                }
            }
        }
        
    }
    
    
    @IBAction func segmentControllerToggled(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            mode = .signUp
            logInSignUpButton.setTitle("Sign Up", for: .normal)
        } else if sender.selectedSegmentIndex == 1 {
            mode = .signIn
            logInSignUpButton.setTitle("Sign In", for: .normal)
        }
    }
    
 

}
