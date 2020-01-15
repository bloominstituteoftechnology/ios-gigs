//
//  LoginViewController.swift
//  gigs
//
//  Created by Kenny on 1/15/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    //MARK: IBOutlets
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var usernamePasswordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    //MARK: IBActions
    @IBAction func loginMethodWasChanged(_ sender: UISegmentedControl) {
        
    }
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    }
    

}
