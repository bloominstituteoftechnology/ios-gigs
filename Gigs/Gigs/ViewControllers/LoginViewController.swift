//
//  LoginViewController.swift
//  Gigs
//
//  Created by Rick Wolter on 10/30/19.
//  Copyright © 2019 Richar Wolter. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var userNameTextFiled: UITextField!
    
    @IBOutlet weak var userPasswordTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func segmentToggled(_ sender: UISegmentedControl) {
    }
    
    @IBAction func buttonClicked(_ sender: UIButton) {
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
