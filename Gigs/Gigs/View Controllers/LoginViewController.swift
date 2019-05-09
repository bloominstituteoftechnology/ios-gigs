//
//  LoginViewController.swift
//  Gigs
//
//  Created by Sameera Roussi on 5/9/19.
//  Copyright © 2019 Sameera Roussi. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: -Properties

    // MARK: Outlets
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var userNameTextLabel: UITextField!
    @IBOutlet weak var passwordTextLabel: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func segmentControlTapped(_ sender: Any) {
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
