//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Hayden Hastings on 5/16/19.
//  Copyright © 2019 Hayden Hastings. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if gigController.bearer == nil {
            performSegue(withIdentifier: "LoginViewModalSegue", sender: self)
        } else {
            gigController.fetchAllGigs { (result) in
                
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
    let cell = tableView.dequeueReusableCell(withIdentifier: "GigCell", for: indexPath)
    
    let gigName = gigController.gigs[indexPath.row]
    
    cell.textLabel?.text = gigName.title
    
    let dateFormate = DateFormatter()
    dateFormate.dateStyle = .short
    dateFormate.timeStyle = .short
    
    cell.detailTextLabel?.text = dateFormate.string(from: gigName.duedate)
    
    return cell
}

override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "ShowGig" {
        guard let destinationVC = segue.destination as? GigViewController,
            let index = tableView.indexPathForSelectedRow else { return }
        
        destinationVC.gig = gigController.gigs[index.row]
        destinationVC.gigController = gigController
        
    } else if segue.identifier == "CreateGig" {
        guard let destinationVC = segue.destination as? GigViewController else { return }
        destinationVC.gigController = gigController
        
    } else if segue.identifier == "LoginViewModalSegue" {
        guard let destinationVC = segue.destination as? LoginViewController else { return }
        destinationVC.gigController = gigController
    }
    
}

let gigController = GigController()
}
