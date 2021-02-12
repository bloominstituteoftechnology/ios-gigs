//
//  LoginViewController.swift
//  gigs
//
//  Created by James McDougall on 2/11/21.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    
    
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
    }
    
    @IBAction func logInButtonTapped(_ sender: UIButton) {
    }
    
    
}
