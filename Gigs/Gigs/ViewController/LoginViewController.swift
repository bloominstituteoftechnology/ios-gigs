//
//  LoginViewController.swift
//  Gigs
//
//  Created by Kobe McKee on 5/16/19.
//  Copyright © 2019 Kobe McKee. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var entryMethodSegmentedControl: UISegmentedControl!
    
    
    @IBOutlet weak var nameTextField: UITextField!
    
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var enterButton: UIButton!
    
    
    
    @IBAction func entryMethodChanged(_ sender: UISegmentedControl) {
    }
    
    
    
    @IBAction func enterButtonPressed(_ sender: UIButton) {
    }
    
    
    
    
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

}
