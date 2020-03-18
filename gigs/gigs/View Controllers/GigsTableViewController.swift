//
//  GigsTableViewController.swift
//  gigs
//
//  Created by Waseem Idelbi on 3/17/20.
//  Copyright © 2020 WaseemID. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        letUserLoginIfNecessary()
    }
    
    //MARK: -Properties-
    
    var gigController = GigController()
    
    
    //MARK: -Methods-
    
    func letUserLoginIfNecessary() {
        if gigController.bearer == nil {
            performSegue(withIdentifier: "LoginSegue", sender: self)
        }
        // TODO: fetch gigs here
    }
    
    
    // MARK: - Table view data source -
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigCell", for: indexPath)
        
        // Configure the cell...
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginSegue" {
            let loginVC = segue.destination as! LoginViewController
            loginVC.gigController = gigController
        }
    }
    
} //End of class
