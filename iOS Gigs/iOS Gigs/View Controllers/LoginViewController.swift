//
//  LoginViewController.swift
//  iOS Gigs
//
//  Created by Brandi on 10/30/19.
//  Copyright © 2019 Brandi. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case signIn
}

class LoginViewController: UIViewController {
    
    var gigController: GigController!
    var loginType = LoginType.signUp

    @IBOutlet weak var signInSegmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        signInButton.backgroundColor = UIColor(hue: 195/360, saturation: 93/100, brightness: 44/100, alpha: 1.0)
            signInButton.tintColor = .white
            signInButton.layer.cornerRadius = 4.0
        // Do any additional setup after loading the view.
    }
    
    @IBAction func segementedControlChanged(_ sender: Any) {
    }
    
    @IBAction func signinButtonTapped(_ sender: Any) {
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
