//
//  SignInViewController.swift
//  Gigs
//
//  Created by James McDougall on 2/1/21.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func segmentedControllerChanged(_ sender: UISegmentedControl) {
    }
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        
    }
    
    
}
