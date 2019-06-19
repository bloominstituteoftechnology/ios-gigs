//
//  LoginViewController.swift
//  Gigs
//
//  Created by Jake Connerly on 6/19/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    //
    //MARK: - Outlets and Properties
    //
    
    @IBOutlet weak var logInSegmentedControl: UISegmentedControl!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    
    //
    //MARK: - View LifeCycle
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //
    // MARK:- IBActions
    //
    
    @IBAction func logInSegmentedControlValueChange(_ sender: UISegmentedControl) {
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
