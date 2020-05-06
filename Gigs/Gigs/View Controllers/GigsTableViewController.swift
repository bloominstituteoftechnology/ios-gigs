//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Nonye on 5/5/20.
//  Copyright © 2020 Nonye Ezekwo. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    let gigController = GigController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if gigController.bearer == nil {
            performSegue(withIdentifier: "SignUpInSegue", sender: self)
        }
    }
    // MARK: - Table view data source
 
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "", for: indexPath)
        
        return cell
    }
    
    // MARK: - Navigation
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SignInUpSegue" {
            if let signUpInVC = segue.destination as? LoginViewController {
                signUpInVC.gigController = gigController
            }
        }    else if segue.identifier == "ShowGigSegue" {
            //inject dependencies
            if let detailVC = segue.destination as? GigDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow {
                detailVC.gigController = gigController
                
            }
        }
    }
}
