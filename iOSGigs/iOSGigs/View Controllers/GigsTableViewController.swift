//
//  GigsTableViewController.swift
//  iOSGigs
//
//  Created by Hunter Oppel on 4/7/20.
//  Copyright © 2020 LambdaSchool. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    // MARK: Properties
    
    let gigController = GigController()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if GigController.bearer == nil {
            performSegue(withIdentifier: "LoginViewController", sender: self)
        }
        // TODO: fetch gigs here
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginViewController" {
            guard let loginVC = segue.destination as? LoginViewController else { return }
            
            loginVC.gigController = gigController
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "", for: indexPath)
          
     return cell
     } 
}
