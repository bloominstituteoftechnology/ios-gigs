//
//  LoginViewController.swift
//  Gigs
//
//  Created by Karen Rodriguez on 3/11/20.
//  Copyright © 2020 Hector Ledesma. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var userSubmitButton: UIButton!
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

    @IBAction func segmentChange(_ sender: Any) {
    }
    @IBAction func userSubmitTapped(_ sender: Any) {
    }
    
}
