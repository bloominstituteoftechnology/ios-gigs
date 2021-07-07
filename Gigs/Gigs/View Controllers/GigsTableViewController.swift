//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Thomas Cacciatore on 5/16/19.
//  Copyright © 2019 Thomas Cacciatore. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    var gigController = GigController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if gigController.bearer == nil {
            // Send the user to the login VC.
            
            performSegue(withIdentifier: "LoginSegue", sender: self)
        } else {
            gigController.getAllGigs { (result) in
                do {
                    self.gigController.gigs = try result.get()
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch {
                    NSLog("Error getting gigs")
                }
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return gigController.gigs.count
        
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigsCell", for: indexPath)

        let gigName = gigController.gigs[indexPath.row]
        cell.textLabel?.text = gigName.title

        return cell
    }
 


}
