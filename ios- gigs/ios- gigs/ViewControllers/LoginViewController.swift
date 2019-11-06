//
//  LoginViewController.swift
//  ios- gigs
//
//  Created by Nicolas Rios on 11/3/19.
//  Copyright © 2019 Nicolas Rios. All rights reserved.
//

import UIKit
enum LoginType {
    case signUp
    case signIn
}
class LoginViewController: UIViewController{
    
    var gigController:GigController?
    
    var loginType = LoginType.signUp
         
    //MARK- IBOutlets
    
    @IBOutlet weak var PassWordTextField: UITextField!
    @IBOutlet weak var UserNameTextField: UITextField!
   

    
    
    @IBAction func SignUpLogin(_ sender: Any) {
        
    }
    
    
    @IBAction func UserTappedButton(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
}

// MARK: - Action Handlers
